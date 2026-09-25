# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/features/scene_audit/feature')

module MuriloEduardo
  module VRayToolkit
    module Tests

      class TC_SceneAudit < TestUp::TestCase

        SceneAudit = Features::SceneAudit

        def setup
          start_with_empty_model
        end

        def test_command_is_registered
          assert_kind_of(Commands::Spec, Commands[:scene_audit])
        end

        def test_collect_reports_unused_material
          Sketchup.active_model.materials.add('Spare')

          findings = SceneAudit.analyze(Sketchup.active_model).findings

          assert(findings.any? { |finding| finding.code == :unused_material && finding.subject == 'Spare' })
        end

        def test_collect_reads_vray_scene
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?

          data = SceneAudit.collect(Sketchup.active_model)

          assert_kind_of(Array, data[:file_references])
          assert_operator(data[:plugin_counts].fetch(:settings, 0), :>, 0)
          data[:file_references].each { |reference| assert_includes([true, false], reference[:exists]) }
        end

        def test_collect_leaves_vray_context_inactive_if_it_was
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?
          VRayBridge.deactivate

          SceneAudit.collect(Sketchup.active_model)

          assert_nil(::VRay::Context.active(false))
        end

        def test_report_html_mentions_material
          Sketchup.active_model.materials.add('Spare <1>')

          html = SceneAudit::Report.render(SceneAudit.analyze(Sketchup.active_model))

          assert_includes(html, 'Spare &lt;1&gt;')
        end

        def test_file_exists_resolves_model_relative_paths
          folder = Sketchup.temp_dir
          name = 'me_vray_toolkit_exists_probe.txt'
          File.write(File.join(folder, name), 'x')

          assert(SceneAudit.file_exists?(name, folder))
          refute(SceneAudit.file_exists?('does/not/exist.png', folder))
          refute(SceneAudit.file_exists?('relative.png', nil))
        end

      end

    end
  end
end
