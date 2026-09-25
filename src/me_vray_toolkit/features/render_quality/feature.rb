# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Picks V-Ray's render quality preset (Low … High+).
      module RenderQuality

        STRINGS = {
          'en' => {
            menu_item: 'Render Quality...',
            title: 'V-Ray Render Quality',
            prompt: 'Quality',
            vray_missing: 'V-Ray for SketchUp is not loaded.',
            operation: 'Set V-Ray Quality',
          },
          'pt-BR' => {
            menu_item: 'Qualidade do Render...',
            title: 'Qualidade do Render V-Ray',
            prompt: 'Qualidade',
            vray_missing: 'O V-Ray for SketchUp não está carregado.',
            operation: 'Definir Qualidade V-Ray',
          },
          'es' => {
            menu_item: 'Calidad de Render...',
            title: 'Calidad de Render V-Ray',
            prompt: 'Calidad',
            vray_missing: 'V-Ray for SketchUp no está cargado.',
            operation: 'Definir Calidad V-Ray',
          },
        }.freeze

        def self.run
          unless VRayBridge.available?
            UI.messagebox(t(:vray_missing))
            return
          end

          current = VRayBridge::QualityPreset.label_for(VRayBridge.quality_preset)
          labels = VRayBridge::QualityPreset.labels
          input = UI.inputbox([t(:prompt)], [current], [labels.join('|')], t(:title))
          return unless input

          model = Sketchup.active_model
          model.start_operation(t(:operation), true)
          VRayBridge.quality_preset = VRayBridge::QualityPreset.value_for(input.first)
          model.commit_operation
        end

        def self.t(key)
          I18n.t(STRINGS, key)
        end
        private_class_method :t

        Commands.register(id: :render_quality, title: -> { t(:menu_item) }, order: 20) { run }

      end
    end
  end
end
