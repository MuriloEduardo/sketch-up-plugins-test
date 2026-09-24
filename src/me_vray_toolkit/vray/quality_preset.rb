# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Render quality presets exposed by V-Ray for SketchUp through the
      # `/SettingsOptions` plugin, parameter `quality_preset`.
      #
      # Source: Chaos docs, "V-Ray Script Access" (VSKETCHUP/109778336).
      # Pure Ruby: no SketchUp or V-Ray dependency, so it is unit tested in
      # the Docker toolchain.
      module QualityPreset

        PLUGIN_NAME = '/SettingsOptions'
        PARAMETER = :quality_preset

        # @return [Hash{Integer => String}]
        LABELS = {
          0 => 'Low',
          1 => 'Low+',
          2 => 'Medium',
          3 => 'Medium+',
          4 => 'High',
          5 => 'High+',
          6 => 'Custom',
        }.freeze

        # @return [Array<String>]
        def self.labels
          LABELS.values
        end

        # @param value [Integer]
        # @return [String]
        # @raise [ArgumentError] if the value is not a known preset.
        def self.label_for(value)
          LABELS.fetch(value) { raise ArgumentError, "unknown quality preset: #{value.inspect}" }
        end

        # @param label [String] case-insensitive, e.g. "high+" or "Medium".
        # @return [Integer]
        # @raise [ArgumentError] if the label is not a known preset.
        def self.value_for(label)
          normalized = label.to_s.strip.downcase
          entry = LABELS.find { |_value, name| name.downcase == normalized }
          raise ArgumentError, "unknown quality preset: #{label.inspect}" if entry.nil?

          entry.first
        end

      end
    end
  end
end
