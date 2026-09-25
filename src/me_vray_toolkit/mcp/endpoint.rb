# frozen_string_literal: true

require 'json'
require 'uri'

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # The MCP "Streamable HTTP" transport rules for one local endpoint:
      # POST carries JSON-RPC messages, answered with a JSON body (this server
      # never opens event streams); every request needs the bearer token;
      # browsers from other sites are refused by Origin (DNS rebinding).
      #
      # Pure Ruby (needs {Http} and {Protocol}): unit tested in the Docker
      # toolchain.
      class Endpoint

        PATH = '/mcp'
        LOCAL_HOSTS = %w[127.0.0.1 localhost ::1 [::1]].freeze
        JSON_TYPE = 'application/json; charset=utf-8'

        # @param protocol [Protocol]
        # @param token [#call] → String; read on every request so a new token
        #   applies at once
        def initialize(protocol:, token:)
          @protocol = protocol
          @token = token
        end

        # @param request [Http::Request]
        # @return [Array(Integer, Hash{String => String}, String)] status,
        #   headers, body
        def call(request)
          return error(404, 'Not found; the MCP endpoint is /mcp') unless request.path == PATH
          return error(403, 'Origin not allowed') unless local_origin?(request.headers['origin'])
          return error(401, 'Missing or invalid token') unless authorized?(request.headers['authorization'])
          return [405, { 'Allow' => 'POST' }, ''] unless request.http_method == 'POST'

          response = @protocol.handle_json(request.body)
          return [202, {}, ''] if response.nil?

          headers = { 'Content-Type' => JSON_TYPE }
          headers['Mcp-Session-Id'] = session_id if initialize_request?(response, request.body)
          [200, headers, JSON.generate(response)]
        end

        private

        def local_origin?(origin)
          return true if origin.nil? || origin.empty?

          host = URI.parse(origin).host
          LOCAL_HOSTS.include?(host)
        rescue URI::InvalidURIError
          false
        end

        def authorized?(header)
          expected = @token.call.to_s
          given = header.to_s.sub(/\ABearer\s+/i, '')
          !expected.empty? && same_token?(given, expected)
        end

        # Random.urandom, not SecureRandom: OpenSSL can freeze SketchUp on Windows.
        def session_id
          Random.urandom(16).unpack1('H*').unpack('a8a4a4a4a12').join('-')
        end

        # Constant-time comparison, so the token cannot be guessed by timing.
        def same_token?(given, expected)
          return false unless given.bytesize == expected.bytesize

          given.bytes.zip(expected.bytes).reduce(0) { |sum, (a, b)| sum | (a ^ b) }.zero?
        end

        def initialize_request?(response, body)
          response.is_a?(Hash) && response['result'].is_a?(Hash) && response['result'].key?('protocolVersion') &&
            body.include?('"initialize"')
        end

        def error(status, message)
          [status, { 'Content-Type' => JSON_TYPE }, JSON.generate({ error: message })]
        end

      end
    end
  end
end
