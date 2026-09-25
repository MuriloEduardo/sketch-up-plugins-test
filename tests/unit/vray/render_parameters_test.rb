# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/render_parameter_definitions'
require_source 'me_vray_toolkit/vray/render_parameters'
require_source 'me_vray_toolkit/vray/lighting_presets'

class RenderParametersTest < Minitest::Test

  Parameters = MuriloEduardo::VRayToolkit::VRayBridge::RenderParameters
  Presets = MuriloEduardo::VRayToolkit::VRayBridge::LightingPresets

  def test_friendly_values_become_plugin_parameters
    writes = Parameters.to_vray(auto_exposure: 'histogram', f_number: 8, ao_radius: 0.5, sun_enabled: true,
                                background_color: [255, 0, 0])

    assert_equal(['/SettingsCamera', :auto_exposure, 2], writes[0])
    assert_equal(['/CameraPhysical', :f_number, 8.0], writes[1])
    assert_in_delta(19.685, writes[2][2], 0.001)
    assert_equal(['/SunLight', :enabled, true], writes[3])
    assert_equal([1.0, 0.0, 0.0], writes[4][2])
  end

  def test_invalid_values_are_refused
    assert_raises(ArgumentError) { Parameters.to_vray(auto_exposure: 'sometimes') }
    assert_raises(ArgumentError) { Parameters.to_vray(f_number: 500) }
    assert_raises(ArgumentError) { Parameters.to_vray(brightness: 1) }
  end

  def test_readings_become_friendly_values
    readings = {
      ['/CameraPhysical', :exposure] => true, ['/SettingsCamera', :auto_white_balance] => 1,
      ['/SettingsColorMapping', :type] => 6, ['/SettingsGI', :ao_radius] => 39.37007874015748,
      ['/CameraPhysical', :white_balance] => [1.0, 0.5, 0.0],
    }

    friendly = Parameters.from_vray(readings)

    assert_equal('physical', friendly[:camera_exposure])
    assert_equal('temperature', friendly[:auto_white_balance])
    assert_equal('reinhard', friendly[:color_mapping])
    assert_in_delta(1.0, friendly[:ao_radius])
    assert_equal([255, 128, 0], friendly[:white_balance])
    refute(friendly.key?(:white_balance_kelvin))
  end

  def test_group_filter
    readings = { ['/SunLight', :turbidity] => 3.0, ['/CameraPhysical', :ISO] => 100.0 }

    assert_equal({ sky_turbidity: 3.0 }, Parameters.from_vray(readings, group: :sun))
  end

  def test_kelvin_white_points
    assert_equal([1.0, 1.0, 1.0], Parameters.kelvin_to_rgb(6600).map { |channel| channel.round(1) })
    warm = Parameters.kelvin_to_rgb(3000)
    cool = Parameters.kelvin_to_rgb(10_000)

    assert_operator(warm[0], :>, warm[2])
    assert_operator(cool[2], :>, cool[0])
  end

  def test_every_preset_converts
    Presets::PRESETS.each do |name, preset|
      writes = Parameters.to_vray(preset[:parameters])

      refute_empty(writes, name)
      assert(preset[:description].is_a?(String), name)
    end
  end

  def test_presets_using_auto_exposure_keep_the_light_cache
    Presets::PRESETS.each do |name, preset|
      next if preset[:parameters][:auto_exposure].to_s == 'off'

      assert_equal('light_cache', preset[:parameters][:gi_secondary_engine], name)
    end
  end

  def test_params_schema_matches_the_definitions
    schema = Parameters.params_schema

    assert_equal(Parameters::DEFINITIONS.keys, schema.keys)
    assert_equal({ type: :enum, values: %w[off center_weighted histogram],
                   description: Parameters::DEFINITIONS[:auto_exposure][:description], }, schema[:auto_exposure])
    assert_equal(:array, schema[:background_color][:type])
    assert_equal(1000..40_000, schema[:white_balance_kelvin][:range])
  end

  def test_unknown_preset
    assert_raises(ArgumentError) { Presets.fetch('moonlight') }
    assert_equal(Presets::PRESETS.size, Presets.list.size)
  end

end
