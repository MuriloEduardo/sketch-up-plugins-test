# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Registry of typed actions (pillar P8): what a feature can do, with an
    # input schema and no UI. Menu commands, tests and the MCP server call
    # the same actions.
    #
    #   Actions.register(name: 'list_scenes', group: :scenes, title: 'List scenes',
    #                    description: 'Scenes of the open model, in tab order.',
    #                    read_only: true) do |params|
    #     { scenes: ModelData.scenes(Sketchup.active_model) }
    #   end
    #
    # A handler receives the input normalized with {Params} and returns a
    # Hash of plain JSON data. It may add `image: { data:, mime_type: }`
    # (base64) for a picture the agent should see.
    #
    # Pure Ruby (needs {Params} and {Events} loaded): unit tested in the
    # Docker toolchain.
    module Actions

      NAME_PATTERN = /\A[a-z][a-z0-9_]{1,63}\z/

      # @!attribute read_only [Boolean] never changes the model or files
      # @!attribute destructive [Boolean] may delete or overwrite user data
      # @!attribute idempotent [Boolean] repeating it with the same input
      #   has no further effect
      Action = Struct.new(:name, :title, :description, :group, :schema, :read_only, :destructive, :idempotent,
                          :handler, keyword_init: true)

      @actions = {}

      class << self

        OPTIONS = { title: nil, schema: {}, read_only: false, destructive: false, idempotent: false }.freeze

        # Registers (or replaces) an action.
        #
        # @param options [Hash] `title:` (default from the name: "list_scenes"
        #   → "List scenes"), `schema:` ({Params}), `read_only:`,
        #   `destructive:`, `idempotent:` (true when read-only)
        # @return [Action]
        # @raise [ArgumentError] on a bad name or option, or a missing
        #   description/handler
        def register(name:, description:, group:, **options, &handler)
          raise ArgumentError, "invalid action name: #{name.inspect}" unless NAME_PATTERN.match?(name.to_s)
          raise ArgumentError, "description is required for #{name}" if description.to_s.strip.empty?
          raise ArgumentError, "handler block is required for #{name}" unless handler

          unknown = options.keys - OPTIONS.keys
          raise ArgumentError, "unknown option(s) for #{name}: #{unknown.join(', ')}" unless unknown.empty?

          options = OPTIONS.merge(options)
          options[:title] ||= name.to_s.tr('_', ' ').capitalize
          options[:idempotent] ||= options[:read_only]
          @actions[name.to_s] = Action.new(name: name.to_s, description: description, group: group.to_sym,
                                           handler: handler, **options)
        end

        # @return [Array<Action>] sorted by group, then name
        def all
          @actions.values.sort_by { |action| [action.group.to_s, action.name] }
        end

        # @param name [String]
        # @return [Action, nil]
        def [](name)
          @actions[name.to_s]
        end

        # Validates the input and runs the action. Publishes
        # "action.completed" or "action.failed" with the duration, whoever
        # called it (menu, MCP, test).
        #
        # @param name [String]
        # @param input [Hash]
        # @param source [String] who called it, e.g. "mcp", "menu"
        # @return [Hash]
        # @raise [KeyError] if the action does not exist
        # @raise [ArgumentError] on invalid input
        def call(name, input = {}, source: 'code')
          action = @actions.fetch(name.to_s)
          started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          result = action.handler.call(Params.normalize(action.schema, input))
          publish('action.completed', action, source, started)
          result
        rescue StandardError => error
          if action
            publish('action.failed', action, source, started, error: "#{error.class}: #{error.message}",
                                                              error_class: error.class.name,
                                                              backtrace: Array(error.backtrace).first(50))
          end
          raise
        end

        # Removes every action. For tests.
        def clear
          @actions.clear
        end

        private

        def publish(topic, action, source, started, **extra)
          milliseconds = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round
          Events.publish(topic, { name: action.name, group: action.group.to_s, source: source, ms: milliseconds,
                                  read_only: action.read_only, **extra, })
        end

      end

    end
  end
end
