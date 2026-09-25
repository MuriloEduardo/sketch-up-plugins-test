# frozen_string_literal: true

require 'testup/testcase'

Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Tests

      # Runs inside SketchUp via TestUp (`make su-test`).
      class TC_VRayBridge < TestUp::TestCase

        def setup
          start_with_empty_model
        end

        def test_status_reports_sketchup_and_ruby
          status = VRayBridge.status

          assert_equal(Sketchup.version, status[:sketchup_version])
          assert_equal(RUBY_VERSION, status[:ruby_version])
        end

        def test_api_version_reported_when_vray_loaded
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?

          assert_match(/\A\d+\.\d+/, VRayBridge.api_version)
          assert_equal(VRayBridge.api_version, VRayBridge.status[:vray_api_version])
        end

        def test_available_matches_vray_constant
          assert_equal(defined?(::VRay::Context) ? true : false, VRayBridge.available?)
        end

        def test_quality_preset_round_trip
          skip('V-Ray for SketchUp is not loaded') unless VRayBridge.available?
          original = VRayBridge.quality_preset

          VRayBridge.quality_preset = 2

          assert_equal(2, VRayBridge.quality_preset)
        ensure
          VRayBridge.quality_preset = original if original
        end

      end

    end
  end
end
