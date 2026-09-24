# frozen_string_literal: true

require 'sketchup'

Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit

    MENU_TITLE = 'V-Ray Toolkit'

    # Shows SketchUp/V-Ray environment details.
    def self.show_status
      lines = VRayBridge.status.map { |key, value| "#{key}: #{value.inspect}" }
      UI.messagebox(lines.join("\n"), MB_MULTILINE, 'V-Ray Toolkit Status')
    end

    # Lets the user pick the V-Ray render quality preset.
    def self.pick_quality_preset
      unless VRayBridge.available?
        UI.messagebox('V-Ray for SketchUp is not loaded.')
        return
      end

      current = VRayBridge::QualityPreset.label_for(VRayBridge.quality_preset)
      labels = VRayBridge::QualityPreset.labels
      input = UI.inputbox(['Quality'], [current], [labels.join('|')], 'V-Ray Render Quality')
      return unless input

      model = Sketchup.active_model
      model.start_operation('Set V-Ray Quality', true)
      VRayBridge.quality_preset = VRayBridge::QualityPreset.value_for(input.first)
      model.commit_operation
    end

    unless file_loaded?(__FILE__)
      menu = UI.menu('Extensions').add_submenu(MENU_TITLE)
      menu.add_item('Status...') { show_status }
      menu.add_item('Render Quality...') { pick_quality_preset }
      file_loaded(__FILE__)
    end

  end
end
