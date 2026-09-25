# frozen_string_literal: true

require 'fileutils'
require 'testup/testcase'

Sketchup.require('me_vray_toolkit/features/layout_sheets/feature')

module MuriloEduardo
  module VRayToolkit
    module Tests

      # Sheets built on the user's LayOut template instead of the toolkit's
      # own title block.
      class TC_LayoutSheetsTemplate < TestUp::TestCase

        LayoutSheets = Features::LayoutSheets

        def setup
          start_with_empty_model
          @folder = File.join(Sketchup.temp_dir, "me_layout_template_#{Process.pid}_#{rand(1_000_000)}")
          FileUtils.mkdir_p(@folder)
        end

        # Tests save the active model; leave a new, never saved one behind.
        def teardown
          open_new_model
          FileUtils.rm_rf(@folder)
        end

        def test_template_sheets_drop_the_cover_and_keep_the_title_block
          template = builtin_template
          skip('No LayOut title block template installed') unless template
          model = saved_model_with_scenes('P.Planta', 'E.Fachada')

          result = LayoutSheets.generate(model, template: template, index_sheet: false, export_pdf: false)
          document = Layout::Document.open(result[:layout_path])

          assert_equal(%w[P.Planta E.Fachada], document.pages.map(&:name))
          shared = document.layers.select(&:shared?)
          document.pages.each { |page| assert(shared.any? { |layer| page.layer_visible?(layer) }) }
        end

        def test_missing_template_is_an_error
          model = saved_model_with_scenes('P.Planta')

          assert_raises(LayoutSheets::Error) { LayoutSheets.generate(model, template: 'C:/nope/missing.layout') }
        end

        private

        def builtin_template
          Dir.glob('C:/ProgramData/SketchUp/SketchUp 20*/Layout/templates/Titleblock/*/A3 Landscape.layout').first
        end

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
