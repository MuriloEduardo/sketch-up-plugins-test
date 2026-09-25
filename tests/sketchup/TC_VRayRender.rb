# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/core/jobs')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/render_batch')
Sketchup.require('me_vray_toolkit/vray/render_job')

module MuriloEduardo
  module VRayToolkit
    module Tests

      class TC_VRayRender < TestUp::TestCase

        def setup
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?
          start_with_empty_model
        end

        # Tests save the active model; leave a new, never saved one behind.
        def teardown
          open_new_model
        end

        # V-Ray writes its scene into the .skp on save; a context restart
        # reloads it from there.
        def test_render_settings_are_kept_with_the_saved_model
          VRayBridge.update_render_settings(width: 1024, height: 576, noise_limit: 0.023)
          Sketchup.active_model.save(File.join(Sketchup.temp_dir, "me_vray_settings_#{rand(1_000_000)}.skp"))
          VRayBridge.deactivate

          settings = VRayBridge.render_settings

          assert_equal([1024, 576], [settings[:width], settings[:height]])
          assert_in_delta(0.023, settings[:noise_limit], 0.0001)
        end

        def test_unknown_render_setting_is_refused
          assert_raises(ArgumentError) { VRayBridge.update_render_settings(colour: 'red') }
        end

        def test_batch_without_scenes_is_refused
          assert_raises(ArgumentError) do
            VRayBridge::RenderBatch.start(model: Sketchup.active_model, scenes: [], width: 64, height: 48)
          end
        end

        def test_show_scene_applies_the_camera_at_once
          model = Sketchup.active_model
          page = model.pages.add('Probe')
          model.active_view.camera = Sketchup::Camera.new([100, 100, 100], ORIGIN, Z_AXIS)

          VRayBridge::RenderJob.show_scene(model, page)

          assert_equal(page.camera.eye, model.active_view.camera.eye)
        end

        def test_render_job_starts_and_allows_one_at_a_time
          model = Sketchup.active_model
          model.active_entities.add_face([0, 0, 0], [100, 0, 0], [100, 100, 0], [0, 100, 0])

          job = VRayBridge::RenderJob.start(model: model, width: 64, height: 48, max_minutes: 0.05)

          assert_equal(:running, job.state)
          assert_raises(ArgumentError) { VRayBridge::RenderJob.start(model: model, width: 64, height: 48) }
        ensure
          VRayBridge::RenderJob.cancel(job.id) if job && !job.finished?
        end

      end

    end
  end
end
