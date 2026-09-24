# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/vray/plugin_path')
Sketchup.require('me_vray_toolkit/vray/quality_preset')

module MuriloEduardo
  module VRayToolkit
    # Thin, single point of contact with the V-Ray for SketchUp Ruby API
    # ("Script Access"). Everything that touches `::VRay` goes through here so
    # API changes between V-Ray versions only need fixing in one place.
    #
    # Knowledge base: docs/reference/vray-ruby-api.md
    module VRayBridge

      # Raised when V-Ray for SketchUp is not installed or not loaded.
      class NotAvailable < StandardError; end

      # Name fragment used to find V-Ray in SketchUp's Extension Manager.
      EXTENSION_NAME_PATTERN = /V-Ray/i

      # @return [Boolean] whether the V-Ray Ruby API is loaded.
      def self.available?
        defined?(::VRay::Context) ? true : false
      end

      # @return [SketchupExtension, nil] the V-Ray extension, if registered.
      def self.extension
        Sketchup.extensions.find { |extension| extension.name =~ EXTENSION_NAME_PATTERN }
      end

      # @return [String, nil] V-Ray version as shown in the Extension Manager.
      def self.version
        extension&.version
      end

      # Returns the active V-Ray context.
      #
      # Activating the context installs V-Ray's SketchUp observers, which can
      # make heavy model edits several times slower until it is deactivated
      # (see {.deactivate}). Only call this when you actually need V-Ray.
      #
      # @return [Object] a `VRay::Context`
      # @raise [NotAvailable]
      def self.context
        raise NotAvailable, 'V-Ray for SketchUp is not loaded.' unless available?

        ::VRay::Context.active
      end

      # @return [Object] the active `VRay::Scene`
      def self.scene
        context.scene
      end

      # Runs the block inside a V-Ray scene transaction. Every write to scene
      # plugins must happen inside one.
      #
      # @yieldparam scene [Object] the active `VRay::Scene`
      # @return [Object] the block's return value
      def self.change
        current_scene = scene
        result = nil
        current_scene.change { result = yield(current_scene) }
        result
      end

      # Asks V-Ray's UI (Asset Editor etc.) to reload from the scene. Needed
      # after script changes that must show up in the UI.
      def self.refresh_ui
        ::VRay.refresh_ui if ::VRay.respond_to?(:refresh_ui)
      end

      # Deactivates the V-Ray context, removing its observers. Restores full
      # model editing speed; V-Ray reactivates on its next use.
      #
      # Caution: while the Asset Editor is open this can leave it in a bad
      # state (Chaos forum thread 118428).
      def self.deactivate
        return unless available?

        ::VRay::Context.active(false)&.delete
      end

      # @return [Integer] current value of `/SettingsOptions`.`quality_preset`
      def self.quality_preset
        scene[QualityPreset::PLUGIN_NAME][QualityPreset::PARAMETER]
      end

      # @param value [Integer] see {QualityPreset::LABELS}
      def self.quality_preset=(value)
        QualityPreset.label_for(value) # Validates.
        change do |current_scene|
          current_scene[QualityPreset::PLUGIN_NAME][QualityPreset::PARAMETER] = value
        end
        refresh_ui
      end

      # Snapshot of the environment, useful for diagnostics and bug reports.
      #
      # @return [Hash{Symbol => Object}]
      def self.status
        vray_extension = extension
        {
          sketchup_version: Sketchup.version,
          ruby_version: RUBY_VERSION,
          platform: Sketchup.platform,
          vray_extension: vray_extension&.name,
          vray_version: vray_extension&.version,
          vray_extension_loaded: vray_extension&.loaded?,
          vray_api_available: available?,
        }
      end

    end
  end
end
