# frozen_string_literal: true

require 'json'
require 'zlib'

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # Connects this SketchUp to the studio platform so its chat and remote
      # MCP clients reach the same tools as the local server. The cloud cannot
      # call into this computer, so the extension calls out: it polls the
      # platform for queued JSON-RPC messages, answers them with the local
      # MCP {Protocol} and posts the responses back.
      #
      #   POST <url>/api/sketchup/poll    → { calls: [{ id, message }], next_poll_ms, need_tools }
      #   POST <url>/api/sketchup/result  ← { id, response }
      #
      # The platform sets the pace (fast while someone is using it, slow when
      # idle); errors back off. A 401 means the link was revoked and stops it.
      #
      # Pure Ruby (unit tested): HTTP, the clock and the MCP handler are injected.
      class Relay

        POLL_PATH = '/api/sketchup/poll'
        RESULT_PATH = '/api/sketchup/result'
        DEFAULT_DELAY = 20.0
        ERROR_DELAY = 15.0
        MIN_DELAY = 0.5

        # @return [Symbol] :running or :revoked
        attr_reader :state
        # @return [String, nil]
        attr_reader :last_error
        # @return [Time, nil] last answer from the platform
        attr_reader :last_contact

        # What this SketchUp offers: `handler` (JSON String → response Hash or
        # nil, usually Service.handle_json), `tools` (→ tools/list result) and
        # `info` (→ versions sent with every poll).
        Local = Struct.new(:handler, :tools, :info, keyword_init: true)

        # @param url [String] platform base URL
        # @param token [String] device token (lrd_…)
        # @param local [Local]
        # @param post [#call] (url, headers, body) { |status, body| }
        # @param clock [#call] → Time
        def initialize(url:, token:, local:, post:, clock: -> { Time.now })
          @url = url.chomp('/')
          @token = token
          @handler = local.handler
          @tools = local.tools
          @info = local.info
          @post = post
          @clock = clock
          @state = :running
          @next_at = clock.call
          @in_flight = false
          @send_tools = true
        end

        # Call often (e.g. every half second); polls when it is time.
        #
        # @return [Symbol, nil] :polled when a poll was sent
        def tick
          return if @in_flight || @state != :running || @clock.call < @next_at

          poll
          :polled
        end

        def running? = @state == :running

        private

        def poll
          tools = @tools.call
          body = { info: @info.call, tools_hash: Zlib.crc32(JSON.generate(tools)).to_s(16) }
          body[:tools] = tools if @send_tools
          @in_flight = true
          request(POLL_PATH, body) { |status, text| polled(status, text) }
        end

        def polled(status, text)
          @in_flight = false
          case status.to_i
          when 200..299 then accept(JSON.parse(text.to_s))
          when 401
            @state = :revoked
            @last_error = 'This computer was disconnected from the account (token revoked).'
          else fail_with("HTTP #{status}: #{text.to_s[0, 200]}")
          end
        rescue JSON::ParserError => error
          fail_with("Invalid answer from the platform: #{error.message}")
        end

        def accept(data)
          @last_contact = @clock.call
          @last_error = nil
          @send_tools = data['need_tools'] == true
          calls = Array(data['calls'])
          calls.each { |call| run(call) }
          # More may be waiting behind a full batch: ask again right away.
          delay = calls.empty? ? (data['next_poll_ms'] || (DEFAULT_DELAY * 1000)).to_f / 1000 : 0
          @next_at = @clock.call + [delay, calls.empty? ? MIN_DELAY : 0].max
        end

        def run(call)
          message = call['message']
          response = begin
            @handler.call(JSON.generate(message))
          rescue StandardError => error
            error_response(message, "#{error.class}: #{error.message}")
          end
          response ||= { 'jsonrpc' => '2.0', 'id' => message.is_a?(Hash) ? message['id'] : nil, 'result' => {} }
          request(RESULT_PATH, { id: call['id'], response: response }) { |_status, _text| nil }
        end

        def error_response(message, text)
          { 'jsonrpc' => '2.0', 'id' => message.is_a?(Hash) ? message['id'] : nil,
            'error' => { 'code' => -32_603, 'message' => text }, }
        end

        def fail_with(message)
          @last_error = message
          @next_at = @clock.call + ERROR_DELAY
        end

        def request(path, body, &)
          headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{@token}" }
          @post.call("#{@url}#{path}", headers, JSON.generate(body), &)
        rescue StandardError => error
          @in_flight = false if path == POLL_PATH
          fail_with("#{error.class}: #{error.message}")
        end

      end
    end
  end
end
