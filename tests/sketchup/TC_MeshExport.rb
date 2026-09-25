# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/sketchup/mesh_export')

module MuriloEduardo
  module VRayToolkit
    module Tests

      class TC_MeshExport < TestUp::TestCase

        def setup
          start_with_empty_model
        end

        def test_box_exports_six_faces_and_twelve_edges
          add_box(Sketchup.active_model.active_entities)

          snapshot = MeshExport.snapshot(Sketchup.active_model)

          assert_equal(6, snapshot[:faces])
          assert_equal(12 * 6, snapshot[:edges].size)
          assert_equal(12, snapshot[:meshes].sum { |mesh| mesh[:indices].size / 3 })
        end

        def test_coordinates_are_in_meters_and_follow_group_transformations
          group = Sketchup.active_model.active_entities.add_group
          add_box(group.entities)
          group.transform!(Geom::Transformation.new([1.m, 0, 0]))

          positions = MeshExport.snapshot(Sketchup.active_model)[:meshes].first[:positions]
          xs = positions.each_slice(3).map(&:first)

          assert_in_delta(1.0, xs.min, 0.0001)
          assert_in_delta(1.0254, xs.max, 0.0001)
        end

        def test_materials_group_triangles_by_color
          model = Sketchup.active_model
          group = model.active_entities.add_group
          add_box(group.entities)
          group.material = model.materials.add('Red').tap { |material| material.color = [200, 10, 10] }

          snapshot = MeshExport.snapshot(model)

          assert_equal([[200, 10, 10]], snapshot[:materials].map { |material| material[:color] })
          assert_equal(0, snapshot[:meshes].first[:material])
        end

        def test_hidden_entities_are_skipped
          group = Sketchup.active_model.active_entities.add_group
          add_box(group.entities)
          group.visible = false

          assert_equal(0, MeshExport.snapshot(Sketchup.active_model)[:faces])
        end

        def test_max_faces_truncates
          add_box(Sketchup.active_model.active_entities)

          snapshot = MeshExport.snapshot(Sketchup.active_model, max_faces: 2)

          assert(snapshot[:truncated])
          assert_equal(2, snapshot[:faces])
        end

        private

        # A 1 inch cube.
        def add_box(entities)
          face = entities.add_face([0, 0, 0], [1, 0, 0], [1, 1, 0], [0, 1, 0])
          face.reverse! if face.normal.z.negative?
          face.pushpull(1)
        end

      end

    end
  end
end
