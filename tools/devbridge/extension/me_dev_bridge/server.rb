# frozen_string_literal: true

require 'io/wait'
require 'socket'

module MuriloEduardoDev
  module DevBridge
    # Tiny HTTP server driven by a repeating timer on SketchUp's main thread
    # (the only safe place to call the SketchUp API). One request at a time.
    # The timer is injected so the server can be tested outside SketchUp.
    class Server

      TICK_SECONDS = 0.05
      READ_TIMEOUT_SECONDS = 15
      MAX_BODY_BYTES = 100 * 1024 * 1024
      CHUNK_BYTES = 64 * 1024

      # @param bind [String]
      # @param port [Integer]
      # @param routes [Routes]
      # @param start_timer [#call] (interval, &block) → timer id
      # @param stop_timer [#call] (timer id)
      def initialize(bind:, port:, routes:, start_timer:, stop_timer:)
        @bind = bind
        @port = port
        @routes = routes
        @start_timer = start_timer
        @stop_timer = stop_timer
        @busy = false
      end

      def running? = !@socket.nil?

      def start
        return if running?

        @socket = TCPServer.new(@bind, @port)
        @timer = @start_timer.call(TICK_SECONDS) { tick }
      end

      def stop
        @stop_timer.call(@timer) if @timer
        @socket&.close
        @socket = nil
        @timer = nil
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
        status, payload = @routes.call(request, client.remote_address.ip_address)
        client.write(Http.response(status, payload))
      rescue Http::PayloadTooLarge => error
        client.write(Http.response(413, { ok: false, error: error.message }))
      rescue Http::BadRequest => error
        client.write(Http.response(400, { ok: false, error: error.message }))
      rescue StandardError, ScriptError => error
        # ScriptError covers SyntaxError/LoadError from reloaded extension code.
        payload = {
          ok: false,
          error: error.class.name,
          message: error.message,
          backtrace: Array(error.backtrace).first(Evaluator::BACKTRACE_LINES),
        }
        client.write(Http.response(500, payload))
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
