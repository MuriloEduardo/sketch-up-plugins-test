# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/sketchup/model_data')

module MuriloEduardo
  module VRayToolkit
    module Tests

      class TC_ModelData < TestUp::TestCase

        TEXTURE_WIDTH = 8
        TEXTURE_HEIGHT = 4

        def setup
          start_with_empty_model
        end

        # @return [String] path of a small PNG written to the temp folder
        def texture_file
          image = Sketchup::ImageRep.new
          image.set_data(TEXTURE_WIDTH, TEXTURE_HEIGHT, 24, 0, "\x80".b * (TEXTURE_WIDTH * TEXTURE_HEIGHT * 3))
          path = File.join(Sketchup.temp_dir, 'me_vray_toolkit_test_texture.png')
          image.save_file(path)
          path
        end

        def add_face(entities)
          entities.add_face([0, 0, 0], [10, 0, 0], [10, 10, 0], [0, 10, 0])
        end

        def test_material_usage_counts_faces_back_faces_and_instances
          model = Sketchup.active_model
          wood = model.materials.add('Wood')
          metal = model.materials.add('Metal')
          model.materials.add('Spare')

          face = add_face(model.active_entities)
          face.material = wood
          face.back_material = wood
          group = model.active_entities.add_group
          add_face(group.entities).material = metal
          group.material = wood

          usage = ModelData.material_usage(model)

          assert_equal(3, usage[wood])
          assert_equal(1, usage[metal])
          assert_equal(0, usage[model.materials['Spare']])
        end

        def test_nested_definition_is_counted_once
          model = Sketchup.active_model
          metal = model.materials.add('Metal')
          definition = model.definitions.add('Box')
          add_face(definition.entities).material = metal
          3.times { |index| model.active_entities.add_instance(definition, Geom::Transformation.new([index * 20, 0, 0])) }

          assert_equal(1, ModelData.material_usage(model)[metal])
        end

        def test_materials_report_texture_size
          model = Sketchup.active_model
          material = model.materials.add('Textured')
          material.texture = texture_file
          add_face(model.active_entities).material = material

          data = ModelData.materials(model).find { |entry| entry[:name] == 'Textured' }

          assert_equal(1, data[:uses])
          assert_equal(TEXTURE_WIDTH, data[:texture_width])
          assert_equal(TEXTURE_HEIGHT, data[:texture_height])
          assert_match(/me_vray_toolkit_test_texture\.png\z/, data[:texture_file])
        end

        # TestUp reuses whatever model is open (it may be saved), so the
        # unsaved and saved models are simulated.
        def test_folder_is_nil_for_unsaved_model
          assert_nil(ModelData.folder(Struct.new(:path).new('')))
        end

        def test_folder_of_saved_model
          assert_equal('C:/proj', ModelData.folder(Struct.new(:path).new('C:/proj/Casa.skp')))
        end

      end

    end
  end
end
