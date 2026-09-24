# frozen_string_literal: true

require 'base64'
require 'json'

module MuriloEduardoDev
  module DevBridge
    # Maps authenticated HTTP requests to actions. Collaborators that need
    # SketchUp are injected, so this class is unit tested in Docker.
    #
    #   GET  /ping    environment info
    #   POST /eval    body = Ruby source; header X-Result-Format: json returns the raw value
    #   POST /sync    body = {"files": {"src/...": "<base64>"}, "prune": true}
    #   POST /reload  register new extensions + reload implementation files
    #   POST /test    body = {"filter": "TC_Name#"} (optional) runs TestUp
    class Routes

      TOKEN_HEADER = 'x-dev-token'
      FORMAT_HEADER = 'x-result-format'

      # @param token [String]
      # @param workspace [Workspace]
      # @param info [#call] returns a Hash for /ping
      # @param test_runner [#call] (filter) returns a Hash for /test
      def initialize(token:, workspace:, info:, test_runner:)
        @token = token
        @workspace = workspace
        @info = info
        @test_runner = test_runner
        @evaluations = 0
      end

      # @param request [Http::Request]
      # @param client_address [String]
      # @return [Array(Integer, Hash)] status and JSON payload
      def call(request, client_address)
        return [403, { ok: false, error: 'only local connections' }] unless Security.loopback?(client_address)
        unless Security.token_matches?(@token, request.headers[TOKEN_HEADER])
          return [401, { ok: false, error: 'invalid token' }]
        end

        dispatch(request)
      end

      private

      def dispatch(request)
        case [request.http_method, request.path]
        when ['GET', '/ping'] then [200, { ok: true }.merge(@info.call)]
        when ['POST', '/eval'] then [200, evaluate(request)]
        when ['POST', '/sync'] then [200, sync(request)]
        when ['POST', '/reload'] then [200, { ok: true }.merge(@workspace.reload)]
        when ['POST', '/test'] then [200, @test_runner.call(json_body(request)['filter'])]
        else [404, { ok: false, error: "no route for #{request.http_method} #{request.path}" }]
        end
      end

      def evaluate(request)
        @evaluations += 1
        code = request.body.dup.force_encoding(Encoding::UTF_8)
        json = request.headers[FORMAT_HEADER] == 'json'
        result = Evaluator.run(code, name: "devbridge-#{@evaluations}", json: json)
        return result unless json && result[:ok]

        JSON.generate(result[:result]) # Validates the value is JSON-serializable.
        result
      rescue JSON::GeneratorError, Encoding::UndefinedConversionError => error
        result.merge(ok: false, error: error.class.name, message: "result is not JSON-serializable: #{error.message}",
                     result: result[:result].inspect)
      end

      def sync(request)
        payload = json_body(request)
        files = payload.fetch('files').transform_values { |encoded| Base64.strict_decode64(encoded) }
        { ok: true }.merge(@workspace.sync(files, prune: payload.fetch('prune', true)))
      end

      def json_body(request)
        return {} if request.body.empty?

        JSON.parse(request.body)
      end

    end
  end
end
