# frozen_string_literal: true

require 'fileutils'
require 'testup/testcase'

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/features/layout_sheets/feature')

module MuriloEduardo
  module VRayToolkit
    module Tests

      class TC_LayoutSheets < TestUp::TestCase

        LayoutSheets = Features::LayoutSheets

        def setup
          start_with_empty_model
          @folder = File.join(Sketchup.temp_dir, "me_layout_sheets_#{Process.pid}_#{rand(1_000_000)}")
          FileUtils.mkdir_p(@folder)
        end

        # Tests save the active model; leave a new, never saved one behind so
        # other test cases start from the usual state.
        def teardown
          open_new_model
          FileUtils.rm_rf(@folder)
        end

        def test_command_is_registered
          assert_kind_of(Commands::Spec, Commands[:layout_sheets])
        end

        def test_generate_creates_layout_and_pdf
          model = saved_model_with_scenes('P.Planta', 'E.Fachada')

          result = LayoutSheets.generate(model, paper: 'A4')

          assert_equal(3, result[:sheets].size)
          assert(File.exist?(result[:layout_path]))
          assert(File.exist?(result[:pdf_path]))
          assert_equal(File.join(@folder, 'sheets.layout'), result[:layout_path])
        end

        def test_generated_document_has_one_page_per_sheet
          model = saved_model_with_scenes('P.Planta', 'E.Fachada')

          result = LayoutSheets.generate(model, index_sheet: false, export_pdf: false)
          document = Layout::Document.open(result[:layout_path])

          assert_equal(%w[P.Planta E.Fachada], document.pages.map(&:name))
          assert_nil(result[:pdf_path])
        end

        def test_viewport_shows_the_sheet_scene
          model = saved_model_with_scenes('P.Planta', 'E.Fachada')

          result = LayoutSheets.generate(model, prefix: 'e.', index_sheet: false, export_pdf: false)
          page = Layout::Document.open(result[:layout_path]).pages.first
          viewport = page.entities.grep(Layout::SketchUpModel).first

          assert_equal('E.Fachada', viewport.scenes[viewport.current_scene])
        end

        def test_orthographic_scene_gets_a_standard_scale
          model = Sketchup.active_model
          top = Sketchup::Camera.new([50, 50, 1000], [50, 50, 0], [0, 1, 0])
          top.perspective = false
          model.active_view.camera = top
          saved_model_with_scenes('P.Planta')

          result = LayoutSheets.generate(model, index_sheet: false, export_pdf: false)
          viewport = Layout::Document.open(result[:layout_path]).pages.first.entities
                                     .grep(Layout::SketchUpModel).first

          assert_includes(LayoutSheets::Scale::DENOMINATORS, (1.0 / viewport.scale).round)
        end

        def test_scenes_report_extent_for_orthographic_cameras
          model = Sketchup.active_model
          model.active_entities.add_line([0, 0, 0], [100, 0, 0])
          front = Sketchup::Camera.new([50, -500, 0], [50, 0, 0], [0, 0, 1])
          front.perspective = false
          model.active_view.camera = front
          model.pages.add('E.Frente')

          scene = ModelData.scenes(model).first

          refute(scene[:perspective])
          assert_in_delta(100.0, scene[:extent][0], 0.01)
        end

        def test_generate_never_overwrites
          model = saved_model_with_scenes('P.Planta')

          first = LayoutSheets.generate(model, export_pdf: false)
          second = LayoutSheets.generate(model, export_pdf: false)

          refute_equal(first[:layout_path], second[:layout_path])
          assert_equal(File.join(@folder, 'sheets (2).layout'), second[:layout_path])
        end

        def test_scene_added_after_save_is_skipped
          model = saved_model_with_scenes('P.Planta')
          model.pages.add('P.Unsaved')

          result = LayoutSheets.generate(model, index_sheet: false, export_pdf: false)

          assert_equal(['P.Planta'], result[:sheets])
          assert_equal(['P.Unsaved'], result[:skipped])
        end

        # TestUp reuses the active model (it stays saved after other tests),
        # so an unsaved model is simulated.
        def test_unsaved_model_is_an_error
          unsaved = Struct.new(:path).new('')

          assert_raises(LayoutSheets::Error) { LayoutSheets.generate(unsaved) }
        end

        def test_saved_unmodified_model_is_ready_without_asking
          model = saved_model_with_scenes('P.Planta')

          assert(LayoutSheets::Dialog.ready_to_use?(model))
        end

        def test_no_matching_scene_is_an_error
          model = saved_model_with_scenes('P.Planta')

          assert_raises(LayoutSheets::Error) { LayoutSheets.generate(model, prefix: 'X.') }
        end

        private

        # A box, one scene per name and the model saved in the test folder.
        def saved_model_with_scenes(*names)
          model = Sketchup.active_model
          face = model.active_entities.add_face([0, 0, 0], [100, 0, 0], [100, 100, 0], [0, 100, 0])
          face.reverse! if face.normal.z.negative?
          face.pushpull(50)
          names.each { |name| model.pages.add(name) }
          model.save(File.join(@folder, 'sheets.skp'))
          model
        end

      end

    end
  end
end
