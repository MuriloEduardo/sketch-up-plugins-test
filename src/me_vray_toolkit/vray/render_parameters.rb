# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # The V-Ray parameters that shape how light looks in the render
      # (camera exposure, white balance, tone mapping, GI, sun and sky,
      # environment) under friendly names, units and option names. Meanings
      # from the V-Ray plugin reference; names verified on V-Ray 7.20.
      #
      # Pure Ruby (needs {RenderParameterDefinitions}): unit tested in the
      # Docker toolchain. {VRayBridge} reads and writes them.
      module RenderParameters

        INCHES_PER_METER = 39.37007874015748
        DEFINITIONS = RenderParameterDefinitions::DEFINITIONS

        GROUPS = DEFINITIONS.values.map { |definition| definition[:group] }.uniq.freeze

        class << self

          # @param values [Hash{Symbol => Object}] friendly name => value
          # @return [Array<Array(String, Symbol, Object)>] plugin, parameter, raw
          #   value (colors as [r, g, b] floats 0-1)
          # @raise [ArgumentError] on an unknown name, option or out-of-range value
          def to_vray(values)
            values.map do |key, value|
              definition = DEFINITIONS.fetch(key) { raise ArgumentError, "unknown render parameter: #{key}" }
              [definition[:plugin], definition[:parameter], raw(key, definition, value)]
            end
          end

          # @param readings [Hash{Array(String, Symbol) => Object}] [plugin,
          #   parameter] => raw value (colors as arrays of floats 0-1)
          # @param group [Symbol, nil] only this group
          # @return [Hash{Symbol => Object}] friendly name => value
          def from_vray(readings, group: nil)
            DEFINITIONS.each_with_object({}) do |(key, definition), result|
              next if definition[:write_only] || (group && definition[:group] != group)

              value = readings[[definition[:plugin], definition[:parameter]]]
              result[key] = friendly(definition, value) unless value.nil?
            end
          end

          # The definitions as a {Params} schema (all optional), so tools
          # accept exactly these names with their types and ranges.
          #
          # @return [Hash{Symbol => Hash}]
          def params_schema
            DEFINITIONS.transform_values do |definition|
              field = case definition[:type]
                      when :enum then { type: :enum, values: definition[:values].keys }
                      when :rgb then { type: :array, items: :integer, size: 3 }
                      when :kelvin then { type: :integer }
                      when :boolean then { type: :boolean }
                      else { type: :number }
                      end
              field[:range] = definition[:range] if definition[:range]
              field.merge(description: definition[:description])
            end
          end

          # @return [Array<Array(String, Symbol)>] every [plugin, parameter] to read
          def readable
            DEFINITIONS.values.reject { |definition| definition[:write_only] }
                       .map { |definition| [definition[:plugin], definition[:parameter]] }.uniq
          end

          # Color temperature to an RGB white point (Tanner Helland's fit of
          # blackbody colors), normalized so the brightest channel is 1.
          #
          # @param kelvin [Numeric]
          # @return [Array(Float, Float, Float)]
          def kelvin_to_rgb(kelvin)
            temperature = kelvin.to_f / 100
            red = temperature <= 66 ? 255 : 329.698727446 * ((temperature - 60)**-0.1332047592)
            green = if temperature <= 66
                      (99.4708025861 * Math.log(temperature)) - 161.1195681661
                    else
                      288.1221695283 * ((temperature - 60)**-0.0755148492)
                    end
            blue = if temperature >= 66 then 255
                   elsif temperature <= 19 then 0
                   else (138.5177312231 * Math.log(temperature - 10)) - 305.0447927307
                   end
            channels = [red, green, blue].map { |channel| channel.clamp(0, 255) / 255.0 }
            brightest = channels.max
            channels.map { |channel| (channel / brightest).round(4) }
          end

          private

          def raw(key, definition, value)
            check_range(key, definition, value)
            case definition[:type]
            when :enum
              definition[:values].fetch(value.to_s) do
                raise ArgumentError, "#{key}: expected one of #{definition[:values].keys.join(', ')}"
              end
            when :rgb then Array(value).first(3).map { |channel| (channel.to_f / 255).clamp(0.0, 1.0) }
            when :kelvin then kelvin_to_rgb(value)
            when :length then value.to_f * INCHES_PER_METER
            when :boolean then value ? true : false
            when :integer then value.to_i
            else value.to_f
            end
          end

          def check_range(key, definition, value)
            range = definition[:range]
            return unless range && value.is_a?(Numeric) && !range.cover?(value)

            raise ArgumentError, "#{key}: #{value} is outside #{range}"
          end

          def friendly(definition, value)
            case definition[:type]
            when :enum
              number = { true => 1, false => 0 }.fetch(value) { value.to_i }
              definition[:values].key(number) || value
            when :rgb then Array(value).first(3).map { |channel| (channel.to_f * 255).round.clamp(0, 255) }
            when :length then (value.to_f / INCHES_PER_METER).round(4)
            when :boolean then [true, 1].include?(value)
            else value.is_a?(Float) ? value.round(4) : value
            end
          end

        end

      end
    end
  end
end
