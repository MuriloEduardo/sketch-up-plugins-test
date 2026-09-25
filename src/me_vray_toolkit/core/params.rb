# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Validates the input of a feature action against a schema, so the same
    # action can be called from a menu dialog, a test or an MCP tool.
    #
    #   SCHEMA = {
    #     prefix: { type: :string, default: '', description: 'Scene name prefix' },
    #     paper: { type: :enum, values: %w[A4 A3], default: 'A3' },
    #     export_pdf: { type: :boolean, default: true },
    #     point: { type: :array, items: :number, size: 3, required: true },
    #   }.freeze
    #   Params.normalize(SCHEMA, 'paper' => 'A4', 'point' => [0, 0, 0])
    #
    # A field with `required: true` has no default and must be given; any
    # other field without `default:` is optional and absent means nil.
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    module Params

      TYPES = %i[string boolean integer number enum array].freeze

      BOOLEANS = {
        true => true, false => false,
        'true' => true, 'false' => false, 'yes' => true, 'no' => false, '1' => true, '0' => false,
      }.freeze

      JSON_TYPES = { string: 'string', boolean: 'boolean', integer: 'integer', number: 'number' }.freeze

      class << self

        # @param schema [Hash{Symbol => Hash}] field => `{ type:, default:,
        #   values:, range:, items:, size:, required:, description: }`
        # @param input [Hash] String or Symbol keys
        # @return [Hash{Symbol => Object}]
        # @raise [ArgumentError] on unknown or missing fields and invalid values
        def normalize(schema, input)
          input = (input || {}).to_h { |key, value| [key.to_sym, value] }
          unknown = input.keys - schema.keys
          raise ArgumentError, "unknown parameter(s): #{unknown.join(', ')}" unless unknown.empty?

          schema.to_h do |name, field|
            given = input.key?(name) && !input[name].nil?
            raise ArgumentError, "#{name}: required" if field[:required] && !given

            [name, given ? coerce(name, field, input[name]) : field[:default]]
          end
        end

        # The schema as JSON Schema (draft 2020-12 subset), as MCP tools
        # publish their `inputSchema`.
        #
        # @param schema [Hash{Symbol => Hash}]
        # @return [Hash]
        def json_schema(schema)
          properties = schema.to_h { |name, field| [name.to_s, property(field)] }
          required = schema.select { |_name, field| field[:required] }.keys.map(&:to_s)
          result = { 'type' => 'object', 'properties' => properties, 'additionalProperties' => false }
          result['required'] = required unless required.empty?
          result
        end

        private

        def property(field)
          type = field.fetch(:type)
          result = case type
                   when :enum then { 'type' => 'string', 'enum' => field.fetch(:values) }
                   when :array then array_property(field)
                   else { 'type' => JSON_TYPES.fetch(type) }
                   end
          result['description'] = field[:description] if field[:description]
          result['default'] = field[:default] unless field[:default].nil?
          add_range(result, field[:range])
          result
        end

        def array_property(field)
          result = { 'type' => 'array', 'items' => { 'type' => JSON_TYPES.fetch(field.fetch(:items)) } }
          result['minItems'] = result['maxItems'] = field[:size] if field[:size]
          result
        end

        def add_range(result, range)
          return if range.nil?

          result['minimum'] = range.begin if range.begin
          result['maximum'] = range.end if range.end && !range.exclude_end?
        end

        def coerce(name, field, value)
          case field.fetch(:type)
          when :string then value.to_s.strip
          when :boolean then boolean(name, value)
          when :integer then integer(name, field, value)
          when :number then number(name, field, value)
          when :enum then enum(name, field, value)
          when :array then array(name, field, value)
          else raise ArgumentError, "#{name}: unsupported type #{field[:type]}"
          end
        end

        def boolean(name, value)
          key = value.is_a?(String) ? value.strip.downcase : value
          BOOLEANS.fetch(key) { raise ArgumentError, "#{name}: expected true or false, got #{value.inspect}" }
        end

        def integer(name, field, value)
          number = value.is_a?(Float) && value == value.floor ? value.to_i : Integer(value, exception: false)
          raise ArgumentError, "#{name}: expected an integer, got #{value.inspect}" if number.nil?

          check_range(name, field[:range], number)
        end

        def number(name, field, value)
          number = value.is_a?(Numeric) ? value.to_f : Float(value, exception: false)
          raise ArgumentError, "#{name}: expected a number, got #{value.inspect}" if number.nil? || !number.finite?

          check_range(name, field[:range], number)
        end

        def check_range(name, range, number)
          raise ArgumentError, "#{name}: #{number} is outside #{range}" if range && !range.cover?(number)

          number
        end

        def enum(name, field, value)
          values = field.fetch(:values)
          match = values.find { |allowed| allowed.casecmp?(value.to_s.strip) }
          raise ArgumentError, "#{name}: expected one of #{values.join(', ')}, got #{value.inspect}" if match.nil?

          match
        end

        def array(name, field, value)
          raise ArgumentError, "#{name}: expected a list, got #{value.inspect}" unless value.is_a?(Array)

          size = field[:size]
          raise ArgumentError, "#{name}: expected #{size} items, got #{value.size}" if size && value.size != size

          item = { type: field.fetch(:items) }
          value.each_with_index.map { |element, index| coerce("#{name}[#{index}]", item, element) }
        end

      end

    end
  end
end
