# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Friendly VRayMtl settings (0-1 amounts, 0-255 colors) → parameters of
      # the BRDFVRayMtl child plugin ("user data" layer, verified on 7.20).
      # Colors come out as [r, g, b] floats 0-1; the bridge makes VRay::Color.
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module MaterialParameters

        # friendly name => [parameter, kind]; kind :rgb (0-255 in),
        # :gray (0-1 amount as a gray color) or :float
        MAP = {
          diffuse_color: [:diffuse_color, :rgb],
          reflection: [:reflect_color, :gray],
          glossiness: [:reflect_glossiness_float, :float],
          metalness: [:metalness_float, :float],
          roughness: [:roughness_float, :float],
          refraction: [:refract_color, :gray],
          ior: [:refract_ior_float, :float],
          refraction_glossiness: [:refract_glossiness_float, :float],
          opacity: [:opacity_float, :float],
          coat: [:coat_amount_float, :float],
          self_illumination: [:self_illumination_color, :rgb],
        }.freeze

        # @param values [Hash{Symbol => Object}] keys of MAP
        # @return [Hash{Symbol => Object}] parameter => Float or [r, g, b] 0-1
        # @raise [ArgumentError] on an unknown key
        def self.to_vray(values)
          values.to_h do |key, value|
            parameter, kind = MAP.fetch(key) { raise ArgumentError, "unknown material setting: #{key}" }
            converted = case kind
                        when :rgb then value.map { |channel| (channel.to_f / 255).clamp(0.0, 1.0) }
                        when :gray then [value.to_f.clamp(0.0, 1.0)] * 3
                        else value.to_f
                        end
            [parameter, converted]
          end
        end

        # @param parameters [Hash{Symbol => Object}] parameter => Float or
        #   [r, g, b] 0-1 (as read from the plugin)
        # @return [Hash{Symbol => Object}] friendly name => value
        def self.from_vray(parameters)
          MAP.each_with_object({}) do |(key, (parameter, kind)), result|
            next unless parameters.key?(parameter)

            value = parameters[parameter]
            result[key] = case kind
                          when :rgb then value.first(3).map { |channel| (channel * 255).round.clamp(0, 255) }
                          when :gray then value.first(3).sum.fdiv(3).round(3)
                          else value.to_f.round(4)
                          end
          end
        end

      end
    end
  end
end
