# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Tools about the model as a whole.
        module Model

          extend Support

          LENGTH_UNITS = { 0 => 'inches', 1 => 'feet', 2 => 'millimeters', 3 => 'centimeters', 4 => 'meters',
                           5 => 'yards', }.freeze

          Actions.register(
              name: 'model_info', group: :model, read_only: true,
              description: 'Facts about the SketchUp model open on the user\'s computer: title, file, units, ' \
                           'overall size in meters, counts of entities, components, materials, tags and scenes, ' \
                           'and whether V-Ray is available. Call this first.'
            ) do
            {
              title: model.title, path: model.path, saved: !model.path.empty?, modified: model.modified?,
              sketchup_version: Sketchup.version, units: LENGTH_UNITS[model.options['UnitsOptions']['LengthUnit']],
              size_m: size(model.bounds),
              counts: {
                top_level_entities: model.entities.size,
                definitions: model.definitions.count { |definition| !definition.image? },
                materials: model.materials.size, tags: model.layers.size, scenes: model.pages.size,
                selected: model.selection.size,
              },
              vray: VRayBridge.status.slice(:vray_version, :vray_api_available),
            }
          end

        end
      end
    end
  end
end
