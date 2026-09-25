# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/light_placement')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # V-Ray lights: list, create (placed and aimed), change.
        module Lights

          extend Support

          Placement = VRayBridge::LightPlacement
          POINT = { type: :array, items: :number, size: 3 }.freeze
          COLOR = { type: :array, items: :integer, size: 3, description: 'RGB, 0-255' }.freeze

          # Light plugin "/Rectangle Light" ↔ component definition "Rectangle Light".
          def self.instances(plugin_name)
            definition = model.definitions[plugin_name.delete_prefix('/')]
            return [] unless definition

            definition.instances.map do |instance|
              transformation = instance.transformation
              { persistent_id: instance.persistent_id, position_m: transformation.origin.to_a.map { |v| meters(v) },
                shines_toward: transformation.zaxis.reverse.to_a.map { |v| v.round(3) }, }
            end
          end

          # Tool arguments (meters, 0-255) → V-Ray light parameters (inches, color).
          def self.parameters(params)
            values = params.slice(:enabled, :intensity, :color, :invisible, :intensity_multiplier).compact
            values[:u_size] = Placement.inches(params[:width] / 2.0) if params[:width]
            values[:v_size] = Placement.inches(params[:height] / 2.0) if params[:height]
            values[:radius] = Placement.inches(params[:radius]) if params[:radius]
            values
          end

          SETTINGS = {
            intensity: { type: :number, range: 0.., description: 'Light intensity (V-Ray default units)' },
            color: COLOR,
            width: { type: :number, range: 0.001.., description: 'Rectangle width in meters' },
            height: { type: :number, range: 0.001.., description: 'Rectangle height in meters' },
            radius: { type: :number, range: 0.001.., description: 'Sphere radius in meters' },
            invisible: { type: :boolean, description: 'Hide the light shape from the camera' },
          }.freeze

          Actions.register(
              name: 'list_lights', group: :vray, read_only: true,
              description: 'V-Ray lights (sun, rectangle, sphere, spot, IES, dome…) with type, on/off, intensity, ' \
                           'color and, for placed lights, position in meters and the direction they shine toward.'
            ) do
            require_vray
            { lights: VRayBridge.lights.map { |light| light.merge(instances: instances(light[:name])) } }
          end

          Actions.register(
              name: 'create_light', group: :vray,
              description: 'Adds a V-Ray light at a position (meters) aimed at a target point (default: straight ' \
                           'down). Rectangle takes width/height, sphere radius, IES and dome a file path (dome ' \
                           'with an HDRI lights the whole scene and needs no position). One undo step.',
              schema: {
                type: { type: :enum, values: VRayBridge::LIGHT_COMMANDS.keys.map(&:to_s), required: true },
                position: POINT.merge(description: 'Light position [x, y, z] in meters'),
                target: POINT.merge(description: 'Point the light shines at [x, y, z] in meters'),
                path: { type: :string, description: 'IES profile or HDRI image file (ies, dome)' },
              }.merge(SETTINGS)
            ) do |params|
            require_vray
            kind = params[:type].to_sym
            raise ArgumentError, 'position is required for this light' if kind != :dome && params[:position].nil?

            options = [:dome, :ies].include?(kind) ? { path: params[:path] }.compact : {}
            name = change('Create V-Ray Light') do
              plugin, definition = VRayBridge.create_light(kind, model: model, **options)
              # V-Ray only uses lights that have an instance in the model; a
              # dome has no position of its own and goes at the origin.
              axes = Placement.axes(params[:position] || [0.0, 0.0, 0.0], params[:target])
              if definition
                model.entities.add_instance(
                    definition, Geom::Transformation.new(Geom::Point3d.new(*axes[:origin]), Geom::Vector3d.new(*axes[:zaxis]))
                  )
              end
              plugin
            end
            values = parameters(params)
            VRayBridge.update_light(name, values) unless values.empty?
            { name: name, instances: instances(name) }
          end

          Actions.register(
              name: 'update_light', group: :vray, idempotent: true,
              description: 'Changes a V-Ray light by name (from list_lights): on/off, intensity, color, size. For ' \
                           'the sun use intensity_multiplier.',
              schema: {
                name: { type: :string, required: true, description: 'Light name, e.g. "/Rectangle Light"' },
                enabled: { type: :boolean, description: 'Turn the light on or off' },
                intensity_multiplier: { type: :number, range: 0.., description: 'Sun only: brightness multiplier' },
              }.merge(SETTINGS)
            ) do |params|
            require_vray
            values = parameters(params)
            raise ArgumentError, 'give at least one change' if values.empty?

            VRayBridge.update_light(params[:name], values)
            VRayBridge.lights.find { |light| light[:name] == params[:name] }
          end

        end
      end
    end
  end
end
