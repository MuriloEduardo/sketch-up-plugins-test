# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Where a light instance goes and where it points. V-Ray lights emit
      # along the instance's local -Z (verified on 7.20: an unrotated
      # rectangle light shines down), so the Z axis points away from the
      # target.
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module LightPlacement

        INCHES_PER_METER = 39.37007874015748
        DOWN = [0.0, 0.0, -1.0].freeze

        # @param position [Array(Float, Float, Float)] meters
        # @param target [Array(Float, Float, Float), nil] meters; nil = straight down
        # @return [Hash] `{ origin: [x, y, z] (inches), zaxis: [x, y, z] (unit) }`
        # @raise [ArgumentError] when target equals position
        def self.axes(position, target = nil)
          direction = target ? target.zip(position).map { |to, from| to - from } : DOWN
          length = Math.sqrt(direction.sum { |value| value * value })
          raise ArgumentError, 'target must differ from position' if length < 1e-9

          { origin: position.map { |value| value * INCHES_PER_METER },
            zaxis: direction.map { |value| -value / length }, }
        end

        # @param meters [Float]
        # @return [Float] inches
        def self.inches(meters)
          meters * INCHES_PER_METER
        end

      end
    end
  end
end
