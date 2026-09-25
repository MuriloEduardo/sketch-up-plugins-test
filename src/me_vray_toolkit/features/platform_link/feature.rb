# frozen_string_literal: true

require 'json'

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/mcp/relay')
Sketchup.require('me_vray_toolkit/mcp/service')
Sketchup.require('me_vray_toolkit/mcp/tools')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/features/platform_link/strings')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Links this SketchUp to the user's account on the studio platform, so
      # the platform chat and remote MCP clients use the same tools as the
      # local server ({Mcp::Relay}). The user types a one-time code shown in
      # My account › SketchUp; the device token is kept in SketchUp's
      # preferences and the link resumes when SketchUp starts.
      module PlatformLink

        PREFERENCES = 'MuriloEduardo_VRayToolkit_Platform'
        DEFAULT_URL = 'https://lilian-rosa-interiores.vercel.app'
        LINK_PATH = '/api/sketchup/link'
        TICK_SECONDS = 0.5
        TOOLS_LIST = JSON.generate(jsonrpc: '2.0', id: 'tools', method: 'tools/list')

        class << self

          # Asks for the platform address and the code, then links.
          def connect
            input = UI.inputbox([t(:prompt_url), t(:prompt_code)], [url || DEFAULT_URL, ''], t(:title))
            return unless input

            base = input[0].to_s.strip.chomp('/')
            body = JSON.generate(code: input[1].to_s, name: ENV.fetch('COMPUTERNAME', 'SketchUp'), info: info)
            Sketchup.status_text = t(:linking)
            post("#{base}#{LINK_PATH}", { 'Content-Type' => 'application/json' }, body) do |status, text|
              linked(base, status, text)
            end
          end

          def disconnect
            stop
            Sketchup.write_default(PREFERENCES, 'token', '')
            UI.messagebox(t(:disconnected))
          end

          def show_status
            return UI.messagebox(t(:not_linked)) unless token
            return UI.messagebox(t(:revoked)) if @relay && !@relay.running?

            contact = @relay&.last_contact&.strftime('%H:%M:%S') || t(:never)
            error = @relay&.last_error ? "\n#{@relay.last_error}" : ''
            UI.messagebox(t(:status, url: url, contact: contact, error: error), MB_MULTILINE)
          end

          # Starts polling when a link exists. Safe to call again.
          def resume
            return if @timer || !token

            local = Mcp::Relay::Local.new(handler: Mcp::Service.method(:handle_json), tools: -> { tools },
                                          info: -> { info })
            @relay = Mcp::Relay.new(url: url, token: token, local: local, post: method(:post))
            @timer = UI.start_timer(TICK_SECONDS, true) { tick }
          end

          def stop
            UI.stop_timer(@timer) if @timer
            @timer = nil
            @relay = nil
          end

          private

          def tick
            @relay&.tick
          rescue StandardError => error
            warn("[#{Product::NAME}] platform link: #{error.class}: #{error.message}")
          end

          def linked(base, status, text)
            Sketchup.status_text = ''
            data = JSON.parse(text.to_s)
            if status.to_i == 201 && data['token']
              stop
              Sketchup.write_default(PREFERENCES, 'url', base)
              Sketchup.write_default(PREFERENCES, 'token', data['token'])
              resume
              UI.messagebox(t(:linked))
            else
              UI.messagebox(t(:link_failed, error: data['error'] || "HTTP #{status}"))
            end
          rescue JSON::ParserError
            UI.messagebox(t(:link_failed, error: "HTTP #{status}"))
          end

          def tools
            Mcp::Service.handle_json(TOOLS_LIST).dig('result', 'tools') || []
          end

          def info
            version = defined?(VRayToolkit::EXTENSION) ? VRayToolkit::EXTENSION.version : nil
            { sketchup: Sketchup.version.to_s, vray: VRayBridge.api_version&.to_s, plugin: version,
              platform: Sketchup.platform.to_s, }
          end

          # Asynchronous HTTP on SketchUp's main thread. The request is kept
          # until its callback runs, or Ruby may collect it mid-flight.
          def post(target, headers, body, &on_response)
            request = Sketchup::Http::Request.new(target, Sketchup::Http::POST)
            request.headers = headers
            request.body = body
            (@requests ||= []) << request
            request.start do |finished, response|
              @requests.delete(finished)
              on_response.call(response.status_code, response.body)
            end
          end

          def url = setting('url')
          def token = setting('token')

          def setting(key)
            value = Sketchup.read_default(PREFERENCES, key, '').to_s
            value.empty? ? nil : value
          end

          def t(key, **values)
            I18n.t(STRINGS, key, **values)
          end

        end

        Commands.register(id: :platform_connect, title: -> { t(:menu_connect) }, order: 7) { connect }
        Commands.register(id: :platform_status, title: -> { t(:menu_status) }, order: 8) { show_status }
        Commands.register(id: :platform_disconnect, title: -> { t(:menu_disconnect) }, order: 9) { disconnect }

        # Linked computers reconnect with SketchUp.
        resume

      end
    end
  end
end
