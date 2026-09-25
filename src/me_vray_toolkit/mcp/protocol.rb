# frozen_string_literal: true

require 'json'

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # A JSON-RPC error to send back to the client.
      class RpcError < StandardError

        attr_reader :code

        def initialize(code, message)
          super(message)
          @code = code
        end

      end

      # The Model Context Protocol over JSON-RPC 2.0: lifecycle, ping and
      # tools, backed by the {Actions} registry. Transport-agnostic: the
      # HTTP server (or a test) hands it parsed messages.
      #
      # Pure Ruby (needs {Actions}, {Params}, {ToolListing} and {ToolResult}): unit
      # tested in the Docker toolchain.
      class Protocol

        # Newest first; the first one is offered when the client asks for an
        # unknown version.
        SUPPORTED_VERSIONS = %w[2025-11-25 2025-06-18 2025-03-26 2024-11-05].freeze

        PARSE_ERROR = -32_700
        INVALID_REQUEST = -32_600
        METHOD_NOT_FOUND = -32_601
        INVALID_PARAMS = -32_602
        INTERNAL_ERROR = -32_603

        # @param actions [#all, #[], #call] usually {Actions}
        # @param server [Hash] `{ name:, version: }` shown to clients
        # @param instructions [String, nil] hints for the model using the tools
        # @param enabled [#call] (Actions::Action) → Boolean; hides tools of
        #   groups the user switched off
        # @param prompts [#list_result, #get_result, nil] usually {Prompts};
        #   failures are published by {Actions} as "action.failed"
        def initialize(actions:, server:, instructions: nil, enabled: ->(_action) { true }, prompts: nil)
          @actions = actions
          @server = { 'name' => server.fetch(:name), 'version' => server.fetch(:version) }
          @instructions = instructions
          @enabled = enabled
          @prompts = prompts
        end

        # @param body [String] raw JSON from the transport
        # @return [Hash, Array<Hash>, nil] response(s); nil when there is
        #   nothing to answer (notifications and responses)
        def handle_json(body)
          message = JSON.parse(body)
        rescue JSON::ParserError => error
          error_response(nil, PARSE_ERROR, "Parse error: #{error.message}")
        else
          handle(message)
        end

        # @param message [Hash, Array<Hash>]
        # @return [Hash, Array<Hash>, nil]
        def handle(message)
          if message.is_a?(Array)
            responses = message.filter_map { |item| handle_one(item) }
            return responses.empty? ? nil : responses
          end
          handle_one(message)
        end

        private

        def handle_one(message)
          return error_response(nil, INVALID_REQUEST, 'Invalid request') unless valid?(message)
          return nil unless message.key?('method') # a response from the client
          return nil unless message.key?('id') # a notification

          id = message['id']
          params = message['params'] || {}
          result = dispatch(message['method'], params)
          { 'jsonrpc' => '2.0', 'id' => id, 'result' => result }
        rescue RpcError => error
          error_response(id, error.code, error.message)
        end

        def valid?(message)
          message.is_a?(Hash) && message['jsonrpc'] == '2.0' &&
            (message.key?('method') ? message['method'].is_a?(String) : message.key?('id'))
        end

        def dispatch(method, params)
          case method
          when 'initialize' then initialize_result(params)
          when 'ping' then {}
          when 'tools/list' then { 'tools' => visible_actions.map { |action| ToolListing.describe(action) } }
          when 'tools/call' then call_tool(params)
          when 'resources/list' then { 'resources' => [] }
          when 'resources/templates/list' then { 'resourceTemplates' => [] }
          when 'prompts/list' then @prompts ? @prompts.list_result : { 'prompts' => [] }
          when 'prompts/get' then prompt(params)
          else raise RpcError.new(METHOD_NOT_FOUND, "Method not found: #{method}")
          end
        end

        def initialize_result(params)
          requested = params['protocolVersion']
          version = SUPPORTED_VERSIONS.include?(requested) ? requested : SUPPORTED_VERSIONS.first
          result = {
            'protocolVersion' => version,
            'capabilities' => capabilities,
            'serverInfo' => @server,
          }
          result['instructions'] = @instructions if @instructions
          result
        end

        def capabilities
          result = { 'tools' => { 'listChanged' => false } }
          result['prompts'] = { 'listChanged' => false } if @prompts
          result
        end

        def prompt(params)
          raise RpcError.new(METHOD_NOT_FOUND, 'This server has no prompts') unless @prompts

          @prompts.get_result(params)
        rescue ArgumentError => error
          raise RpcError.new(INVALID_PARAMS, error.message)
        end

        def visible_actions
          @actions.all.select { |action| @enabled.call(action) }
        end

        def call_tool(params)
          name = params['name'].to_s
          action = @actions[name]
          raise RpcError.new(INVALID_PARAMS, "Unknown tool: #{name}") if action.nil? || !@enabled.call(action)

          ToolResult.success(@actions.call(name, params['arguments'] || {}, source: 'mcp'))
        rescue ArgumentError => error
          ToolResult.failure("Invalid arguments: #{error.message}")
        rescue RpcError
          raise
        rescue StandardError => error
          ToolResult.failure("#{error.class}: #{error.message}")
        end

        def error_response(id, code, message)
          { 'jsonrpc' => '2.0', 'id' => id, 'error' => { 'code' => code, 'message' => message } }
        end

      end
    end
  end
end
