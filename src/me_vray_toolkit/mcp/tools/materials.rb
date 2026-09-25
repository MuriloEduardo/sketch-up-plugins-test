# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/material_parameters')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Materials: V-Ray materials (create, change, convert) and applying
        # any material to entities.
        module Materials

          extend Support

          NAME = { type: :string, required: true, description: 'Material name' }.freeze
          UNIT = { type: :number, range: 0.0..1.0 }.freeze
          RGB = { type: :array, items: :integer, size: 3 }.freeze

          SETTINGS = {
            diffuse_color: RGB.merge(description: 'Base color, RGB 0-255'),
            reflection: UNIT.merge(description: 'Reflection amount 0-1 (0 = matte)'),
            glossiness: UNIT.merge(description: 'Reflection glossiness 0-1 (1 = mirror sharp)'),
            metalness: UNIT.merge(description: '0 = dielectric, 1 = metal'),
            roughness: UNIT.merge(description: 'Diffuse roughness 0-1'),
            refraction: UNIT.merge(description: 'Transparency by refraction 0-1 (glass ~1)'),
            ior: { type: :number, range: 1.0..5.0, description: 'Index of refraction (glass 1.5, water 1.33)' },
            refraction_glossiness: UNIT.merge(description: 'Refraction glossiness 0-1 (frosted < 1)'),
            opacity: UNIT.merge(description: 'Cut-out opacity 0-1'),
            coat: UNIT.merge(description: 'Clear coat amount 0-1 (car paint, varnish)'),
            self_illumination: RGB.merge(description: 'Emitted color, RGB 0-255'),
          }.freeze

          def self.settings_from(params)
            params.slice(*SETTINGS.keys).compact
          end

          def self.find_material(name)
            model.materials[name] || model.materials.find { |material| material.display_name == name } or
              raise ArgumentError, "no material named #{name}"
          end

          Actions.register(
              name: 'list_vray_materials', group: :vray, read_only: true,
              description: 'Materials as V-Ray sees them: plain SketchUp materials and V-Ray materials (VRayMtl) ' \
                           'with their reflection, glossiness, metalness, refraction and other settings.'
            ) do
            require_vray
            { materials: VRayBridge.vray_materials }
          end

          Actions.register(
              name: 'create_vray_material', group: :vray,
              description: 'Creates a V-Ray material (VRayMtl); V-Ray also adds a SketchUp material with the same ' \
                           'name, ready for apply_material. Examples: glass = refraction 1, ior 1.5, ' \
                           'reflection 1; brushed metal = metalness 1, reflection 1, glossiness 0.7.',
              schema: { name: NAME }.merge(SETTINGS)
            ) do |params|
            require_vray
            VRayBridge.create_vray_material(params[:name], settings_from(params))
            VRayBridge.vray_materials.find { |material| material[:name] == params[:name] }
          end

          Actions.register(
              name: 'update_vray_material', group: :vray, idempotent: true,
              description: 'Changes settings of a V-Ray material (only the given ones).',
              schema: { name: NAME }.merge(SETTINGS)
            ) do |params|
            require_vray
            values = settings_from(params)
            raise ArgumentError, 'give at least one setting to change' if values.empty?

            VRayBridge.update_vray_material(params[:name], values)
            VRayBridge.vray_materials.find { |material| material[:name] == params[:name] }
          end

          Actions.register(
              name: 'convert_material_to_vray', group: :vray,
              description: 'Turns a plain SketchUp material into a V-Ray material (keeps color and texture), so ' \
                           'its reflection, glossiness and other V-Ray settings can be changed.',
              schema: { name: NAME }
            ) do |params|
            require_vray
            find_material(params[:name])
            VRayBridge.convert_material_to_vray(params[:name])
            VRayBridge.vray_materials.find { |material| material[:name] == params[:name] }
          end

          Actions.register(
              name: 'apply_material', group: :materials,
              description: 'Paints groups, components or faces with a material: by persistent id (from ' \
                           'get_selection or query tools) or the current selection. One undo step.',
              schema: {
                material: NAME,
                ids: { type: :array, items: :integer, description: 'Persistent ids of the entities to paint' },
                selection: { type: :boolean, default: false, description: 'Paint the current selection' },
              }
            ) do |params|
            material = find_material(params[:material])
            targets = params[:selection] ? model.selection.to_a : []
            if params[:ids]
              found = Array(model.find_entity_by_persistent_id(params[:ids]))
              missing = params[:ids].size - found.compact.size
              raise ArgumentError, "#{missing} id(s) not found" if missing.positive?

              targets.concat(found)
            end
            paintable = targets.uniq.select { |entity| entity.respond_to?(:material=) }
            raise ArgumentError, 'nothing to paint: give ids or selection: true' if paintable.empty?

            change('Apply Material') { paintable.each { |entity| entity.material = material } }
            { material: material.display_name, painted: paintable.size }
          end

        end
      end
    end
  end
end
