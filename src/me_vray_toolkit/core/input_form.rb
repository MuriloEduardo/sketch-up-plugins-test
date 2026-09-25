# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Maps a {Params} schema to the arrays `UI.inputbox` takes (prompts,
    # defaults, drop-down lists) and its answers back to action input, so a
    # feature's menu command and its typed action share one schema.
    #
    # Enum and boolean fields become drop-downs with translated labels.
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    class InputForm

      # @param schema [Hash{Symbol => Hash}] see {Params}
      # @param label [#call] field name => prompt text
      # @param option_label [#call] (field name, value) => drop-down text;
      #   values are enum Strings or true/false
      def initialize(schema, label:, option_label:)
        @schema = schema
        @label = label
        @option_label = option_label
      end

      # @return [Array<String>]
      def prompts
        @schema.keys.map { |name| @label.call(name) }
      end

      # @param values [Hash{Symbol => Object}] current values (e.g. the last
      #   input); fields not given use the schema default
      # @return [Array<String>]
      def defaults(values = {})
        @schema.map do |name, field|
          value = values.fetch(name, field[:default])
          options(name).key(value) || value.to_s
        end
      end

      # @return [Array<String>] "" for free text, "A|B|C" for drop-downs
      def lists
        @schema.keys.map { |name| options(name).keys.join('|') }
      end

      # @param answers [Array<String>] as returned by `UI.inputbox`
      # @return [Hash{Symbol => Object}] ready for {Params.normalize}
      def parse(answers)
        @schema.keys.zip(answers).to_h do |name, answer|
          [name, options(name).fetch(answer) { answer }]
        end
      end

      private

      # @return [Hash{String => Object}] drop-down text => value
      def options(name)
        values = case @schema.fetch(name).fetch(:type)
                 when :enum then @schema[name].fetch(:values)
                 when :boolean then [true, false]
                 else []
                 end
        values.to_h { |value| [@option_label.call(name, value), value] }
      end

    end
  end
end
