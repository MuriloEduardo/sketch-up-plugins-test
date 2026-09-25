# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Registry of user-facing commands. Features register their commands here
    # when loaded; {Menu} builds the SketchUp menu from the registry.
    #
    # Handlers are looked up at invocation time, so reloading a feature during
    # development replaces its behavior without rebuilding the menu.
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    module Commands

      # @!attribute id [Symbol] unique command id, e.g. :scene_audit
      # @!attribute title [String, #call] menu text, or a callable returning it
      #   (evaluated when the menu is built, after the locale is known)
      # @!attribute order [Integer] menu position; lower comes first
      # @!attribute handler [#call]
      Spec = Struct.new(:id, :title, :order, :handler, keyword_init: true) do
        # @return [String]
        def label
          title.respond_to?(:call) ? title.call : title
        end
      end

      @specs = {}
      @last_error = nil

      class << self

        # @return [Exception, nil] the last error raised by a handler, kept for
        #   diagnostics (e.g. inspected through the Dev Bridge)
        attr_reader :last_error

        # Registers (or replaces) a command.
        #
        # @param id [Symbol]
        # @param title [String, #call]
        # @param order [Integer]
        # @yield the command handler
        # @return [Spec]
        # @raise [ArgumentError] on a missing id, title or handler
        def register(id:, title:, order: 100, &handler)
          raise ArgumentError, 'id must be a Symbol' unless id.is_a?(Symbol)
          raise ArgumentError, "title is required for #{id}" if title.nil? || title == ''
          raise ArgumentError, "handler block is required for #{id}" unless handler

          @specs[id] = Spec.new(id: id, title: title, order: order, handler: handler)
        end

        # @return [Array<Spec>] sorted by order, then id
        def all
          @specs.values.sort_by { |spec| [spec.order, spec.id.to_s] }
        end

        # @param id [Symbol]
        # @return [Spec, nil]
        def [](id)
          @specs[id]
        end

        # Runs a command's handler. Errors are passed to `on_error` instead of
        # escaping into SketchUp.
        #
        # @param id [Symbol]
        # @param on_error [#call] receives (spec, error)
        # @return [Object] the handler's return value, or nil on error
        # @raise [KeyError] if the command is not registered
        def invoke(id, on_error:)
          spec = @specs.fetch(id)
          begin
            spec.handler.call
          rescue StandardError => error
            @last_error = error
            on_error.call(spec, error)
            nil
          end
        end

        # Removes every command. For tests.
        def clear
          @specs.clear
          @last_error = nil
        end

      end

    end
  end
end
