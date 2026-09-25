# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/sketchup/model_data')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Read-only listings: materials, tags, components, selection.
        module Inventory

          extend Support

          SELECTION_LIMIT = 200

          Actions.register(
              name: 'list_materials', group: :materials, read_only: true,
              description: 'Materials with color, texture file and size in pixels, and how many faces, groups and ' \
                           'components use each one directly.'
            ) do
            colors = model.materials.to_h { |material| [material.name, material.color.to_a.first(3)] }
            { materials: ModelData.materials(model).map { |material| material.merge(color: colors[material[:name]]) } }
          end

          Actions.register(
              name: 'list_tags', group: :tags, read_only: true,
              description: 'Tags (formerly layers) with visibility and color.'
            ) do
            { tags: model.layers.map { |tag|
              { name: tag.name, visible: tag.visible?, color: tag.color.to_a.first(3) }
            } }
          end

          Actions.register(
              name: 'list_components', group: :components, read_only: true,
              description: 'Component definitions (not groups or images) with description, number of placed ' \
                           'instances and whether they are dynamic components.'
            ) do
            definitions = model.definitions.reject { |definition| definition.group? || definition.image? }
            { components: definitions.map do |definition|
              { name: definition.name, description: definition.description, instances: definition.count_instances,
                dynamic: !definition.attribute_dictionary('dynamic_attributes').nil?, }
            end }
          end

          Actions.register(
              name: 'get_selection', group: :selection, read_only: true,
              description: 'What the user selected: type, persistent id, name, tag, material and size in meters ' \
                           "of each item (first #{SELECTION_LIMIT})."
            ) do
            items = model.selection.first(SELECTION_LIMIT).map { |entity| entity_summary(entity) }
            { count: model.selection.size, items: items }
          end

        end
      end
    end
  end
end
