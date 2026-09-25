# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/params')
Sketchup.require('me_vray_toolkit/mcp/endpoint')
Sketchup.require('me_vray_toolkit/mcp/http')
Sketchup.require('me_vray_toolkit/mcp/prompts')
Sketchup.require('me_vray_toolkit/mcp/protocol')
Sketchup.require('me_vray_toolkit/mcp/tool_listing')
Sketchup.require('me_vray_toolkit/mcp/tool_result')
Sketchup.require('me_vray_toolkit/mcp/server')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # The local MCP server of this extension: token, port, start/stop and
      # whether it starts with SketchUp. Every registered {Actions} is a tool.
      module Service

        PREFERENCES = 'MuriloEduardo_VRayToolkit_Mcp'
        PORTS = (7878..7887)
        SERVER_NAME = 'sketchup-vray-toolkit'

        INSTRUCTIONS = <<~TEXT
          These tools act on the SketchUp model open on the user's computer (with V-Ray and LayOut when
          installed). Start with model_info. Lengths are in meters unless a tool says otherwise. Every change
          is a single undo step the user can revert with Ctrl+Z. Use capture_view to look at the result of a
          change before reporting it.
        TEXT

        class << self

          # @return [String]
          def token
            stored = Sketchup.read_default(PREFERENCES, 'token', '').to_s
            return stored unless stored.empty?

            regenerate_token
          end

          # @return [String] the new token; clients must be reconfigured
          def regenerate_token
            # Random.urandom, not SecureRandom: OpenSSL can freeze SketchUp on Windows.
            Random.urandom(24).unpack1('H*').tap { |value| Sketchup.write_default(PREFERENCES, 'token', value) }
          end

          # @return [Integer] port
          def start
            port = server.start(PORTS)
            Sketchup.write_default(PREFERENCES, 'autostart', true)
            Events.publish('mcp.started', port: port)
            port
          end

          def stop
            server.stop
            Sketchup.write_default(PREFERENCES, 'autostart', false)
            Events.publish('mcp.stopped')
          end

          def running?
            !@server.nil? && @server.running?
          end

          # @return [Boolean] the server was running when SketchUp closed
          def autostart?
            Sketchup.read_default(PREFERENCES, 'autostart', false) ? true : false
          end

          # One MCP message in, the answer out, for transports other than the
          # local HTTP server (development proxy, cloud relay).
          #
          # @param body [String] JSON-RPC message(s)
          # @return [Hash, Array<Hash>, nil]
          def handle_json(body)
            protocol.handle_json(body)
          end

          # @return [String, nil]
          def url
            running? ? "http://#{Server::BIND}:#{server.port}#{Endpoint::PATH}" : nil
          end

          private

          def server
            @server ||= Server.new(
                # The protocol is rebuilt per message (cheap), so reloaded tools
                # and prompts apply even while the server runs.
                endpoint: Endpoint.new(protocol: self, token: -> { token }),
                start_timer: ->(interval, &block) { UI.start_timer(interval, true, &block) },
                stop_timer: ->(id) { UI.stop_timer(id) }
              )
          end

          def protocol
            Protocol.new(actions: Actions, server: { name: SERVER_NAME, version: version }, instructions: INSTRUCTIONS,
                         prompts: Prompts)
          end

          def version
            defined?(VRayToolkit::EXTENSION) ? VRayToolkit::EXTENSION.version : '0.0.0'
          end

        end

      end
    end
  end
end
