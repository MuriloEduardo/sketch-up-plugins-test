# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # MCP prompts: ready-made workflows ("skills") a client offers the user
      # as commands; each one tells the agent which tools to use and in which
      # order.
      #
      #   Prompts.register(name: 'render_setup', description: '…',
      #                    arguments: [{ name: 'scene', description: '…' }]) do |args|
      #     "Render the scene #{args['scene']}…"
      #   end
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module Prompts

        # @!attribute arguments [Array<Hash>] `{ name:, description:, required: }`
        Prompt = Struct.new(:name, :title, :description, :arguments, :builder, keyword_init: true)

        @prompts = {}

        class << self

          # @return [Prompt]
          def register(name:, description:, title: nil, arguments: [], &builder)
            raise ArgumentError, "builder block is required for #{name}" unless builder

            @prompts[name.to_s] = Prompt.new(name: name.to_s, title: title || name.to_s.tr('_', ' ').capitalize,
                                             description: description, arguments: arguments, builder: builder)
          end

          # @return [Hash] `prompts/list` result
          def list_result
            { 'prompts' => @prompts.values.map { |prompt| describe(prompt) } }
          end

          # @param params [Hash] `{ 'name' =>, 'arguments' => {} }`
          # @return [Hash] `prompts/get` result
          # @raise [ArgumentError] unknown prompt or missing required argument
          def get_result(params)
            prompt = @prompts[params['name'].to_s] or raise ArgumentError, "Unknown prompt: #{params['name']}"
            values = (params['arguments'] || {}).transform_keys(&:to_s)
            missing = prompt.arguments.select { |argument| argument[:required] && values[argument[:name]].to_s.empty? }
            raise ArgumentError, "Missing argument(s): #{missing.map { |a| a[:name] }.join(', ')}" unless missing.empty?

            text = prompt.builder.call(values)
            { 'description' => prompt.description,
              'messages' => [{ 'role' => 'user', 'content' => { 'type' => 'text', 'text' => text } }], }
          end

          # Removes every prompt. For tests.
          def clear
            @prompts.clear
          end

          private

          def describe(prompt)
            {
              'name' => prompt.name, 'title' => prompt.title, 'description' => prompt.description,
              'arguments' => prompt.arguments.map do |argument|
                { 'name' => argument[:name], 'description' => argument[:description],
                  'required' => argument[:required] ? true : false, }
              end,
            }
          end

        end

      end
    end
  end
end
