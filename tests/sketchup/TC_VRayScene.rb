# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Tests

      # V-Ray materials and lights created by script (internal commands are
      # checked here so a V-Ray update that breaks them shows up at once).
      class TC_VRayScene < TestUp::TestCase

        def setup
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?
          start_with_empty_model
        end

        def test_created_vray_material_has_settings_and_a_sketchup_twin
          name = "Test Gold #{rand(100_000)}"

          VRayBridge.create_vray_material(name, metalness: 1.0, reflection: 1.0, diffuse_color: [255, 190, 80])
          material = VRayBridge.vray_materials.find { |entry| entry[:name] == name }

          assert_equal('vray', material[:type])
          assert_in_delta(1.0, material[:settings][:metalness], 0.001)
          assert_equal([255, 190, 80], material[:settings][:diffuse_color])
          refute_nil(Sketchup.active_model.materials[name])
        end

        def test_sketchup_material_converts_to_vray
          name = "Test Plain #{rand(100_000)}"
          face = Sketchup.active_model.active_entities.add_face([0, 0, 0], [10, 0, 0], [10, 10, 0])
          face.material = Sketchup.active_model.materials.add(name)

          VRayBridge.convert_material_to_vray(name)
          VRayBridge.update_vray_material(name, reflection: 0.5)

          material = VRayBridge.vray_materials.find { |entry| entry[:name] == name }
          assert_in_delta(0.5, material[:settings][:reflection], 0.001)
        end

        def test_rectangle_light_is_a_plugin_and_a_definition_to_place
          plugin, definition = VRayBridge.create_light(:rectangle, model: Sketchup.active_model, width: 10, height: 5)

          assert(VRayBridge.lights.any? { |light| light[:name] == plugin && light[:type] == 'LightRectangle' })
          assert_equal(plugin.delete_prefix('/'), definition.name)
          assert_equal(0, definition.count_instances)
        end

        def test_light_parameters_update
          plugin, = VRayBridge.create_light(:rectangle, model: Sketchup.active_model)

          VRayBridge.update_light(plugin, intensity: 55.0, color: [255, 0, 0])

          light = VRayBridge.lights.find { |entry| entry[:name] == plugin }
          assert_in_delta(55.0, light[:intensity], 0.001)
          assert_equal([255, 0, 0], light[:color])
        end

      end

    end
  end
end
