# frozen_string_literal: true

require 'io/wait'
require 'socket'

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # Local HTTP server for the MCP endpoint, served by a repeating timer on
      # SketchUp's main thread (the only safe place to call the SketchUp API),
      # one request at a time. Listens on 127.0.0.1 only.
      #
      # The timer is injected so the server runs in tests outside SketchUp
      # (needs {Http}).
      class Server

        BIND = '127.0.0.1'
        TICK_SECONDS = 0.05
        READ_TIMEOUT_SECONDS = 15
        MAX_BODY_BYTES = 10 * 1024 * 1024
        CHUNK_BYTES = 64 * 1024

        # @return [Integer, nil] the port in use while running
        attr_reader :port

        # @param endpoint [#call] (Http::Request) → [status, headers, body]
        # @param start_timer [#call] (interval, &block) → timer id
        # @param stop_timer [#call] (timer id)
        def initialize(endpoint:, start_timer:, stop_timer:)
          @endpoint = endpoint
          @start_timer = start_timer
          @stop_timer = stop_timer
          @busy = false
          @socket = nil
          @timer = nil
          @port = nil
        end

        def running?
          !@socket.nil?
        end

        # Listens on the first free port from `ports`.
        #
        # @param ports [Enumerable<Integer>]
        # @return [Integer] the port
        # @raise [Errno::EADDRINUSE] if every port is taken
        def start(ports)
          return @port if running?

          error = nil
          ports.each do |candidate|
            @socket = TCPServer.new(BIND, candidate)
            @port = @socket.addr[1]
            break
          rescue Errno::EADDRINUSE, Errno::EACCES => failure
            error = failure
          end
          raise error || Errno::EADDRINUSE unless @socket

          @timer = @start_timer.call(TICK_SECONDS) { tick }
          @port
        end

        def stop
          @stop_timer.call(@timer) if @timer
          @socket&.close
          @socket = nil
          @timer = nil
          @port = nil
        end

        # Accepts and serves at most one pending connection.
        def tick
          return if @busy || !running?

          client = @socket.accept_nonblock(exception: false)
          return if client == :wait_readable

          begin
            @busy = true
            serve(client)
          ensure
            client.close
            @busy = false
          end
        end

        private

        def serve(client)
          request = Http.parse(read_request(client), max_body: MAX_BODY_BYTES)
          status, headers, body = @endpoint.call(request)
          client.write(Http.response(status, body: body, headers: headers))
        rescue Http::PayloadTooLarge => error
          client.write(Http.response(413, body: error.message))
        rescue Http::BadRequest => error
          client.write(Http.response(400, body: error.message))
        rescue StandardError => error
          client.write(Http.response(500, body: "#{error.class}: #{error.message}"))
        end

        def read_request(client)
          buffer = String.new(encoding: Encoding::BINARY)
          deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + READ_TIMEOUT_SECONDS
          until Http.complete?(buffer, max_body: MAX_BODY_BYTES)
            remaining = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
            raise Http::BadRequest, 'timed out reading request' if remaining <= 0
            next unless client.wait_readable(remaining)

            chunk = client.read_nonblock(CHUNK_BYTES, exception: false)
            next if chunk == :wait_readable
            raise Http::BadRequest, 'connection closed' if chunk.nil?

            buffer << chunk
          end
          buffer
        end

      end
    end
  end
end
