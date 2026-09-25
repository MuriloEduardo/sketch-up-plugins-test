# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Validates the input of a feature action against a schema, so the same
    # action can be called from a menu dialog, a test or (later) an MCP tool.
    #
    #   SCHEMA = {
    #     prefix: { type: :string, default: '' },
    #     paper: { type: :enum, values: %w[A4 A3], default: 'A3' },
    #     export_pdf: { type: :boolean, default: true },
    #   }.freeze
    #   Params.normalize(SCHEMA, 'paper' => 'A4') # => { prefix: '', paper: 'A4', export_pdf: true }
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    module Params

      TYPES = %i[string boolean integer enum].freeze

      BOOLEANS = {
        true => true, false => false,
        'true' => true, 'false' => false, 'yes' => true, 'no' => false, '1' => true, '0' => false,
      }.freeze

      class << self

        # @param schema [Hash{Symbol => Hash}] field => `{ type:, default:, values: }`
        # @param input [Hash] String or Symbol keys; missing fields take their default
        # @return [Hash{Symbol => Object}]
        # @raise [ArgumentError] on unknown fields or invalid values
        def normalize(schema, input)
          input = input.to_h { |key, value| [key.to_sym, value] }
          unknown = input.keys - schema.keys
          raise ArgumentError, "unknown parameter(s): #{unknown.join(', ')}" unless unknown.empty?

          schema.to_h do |name, field|
            value = input.key?(name) ? coerce(name, field, input[name]) : field[:default]
            [name, value]
          end
        end

        private

        def coerce(name, field, value)
          case field.fetch(:type)
          when :string then value.to_s.strip
          when :boolean then boolean(name, value)
          when :integer then integer(name, field, value)
          when :enum then enum(name, field, value)
          else raise ArgumentError, "#{name}: unsupported type #{field[:type]}"
          end
        end

        def boolean(name, value)
          key = value.is_a?(String) ? value.strip.downcase : value
          BOOLEANS.fetch(key) { raise ArgumentError, "#{name}: expected true or false, got #{value.inspect}" }
        end

        def integer(name, field, value)
          number = Integer(value, exception: false)
          raise ArgumentError, "#{name}: expected an integer, got #{value.inspect}" if number.nil?

          range = field[:range]
          raise ArgumentError, "#{name}: #{number} is outside #{range}" if range && !range.cover?(number)

          number
        end

        def enum(name, field, value)
          values = field.fetch(:values)
          match = values.find { |allowed| allowed.casecmp?(value.to_s.strip) }
          raise ArgumentError, "#{name}: expected one of #{values.join(', ')}, got #{value.inspect}" if match.nil?

          match
        end

      end

    end
  end
end
