# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/material_parameters'

class MaterialParametersTest < Minitest::Test

  Parameters = MuriloEduardo::VRayToolkit::VRayBridge::MaterialParameters

  def test_friendly_values_become_vray_parameters
    vray = Parameters.to_vray(diffuse_color: [255, 128, 0], reflection: 0.8, glossiness: 0.9, ior: 1.5)

    assert_equal([1.0, 128 / 255.0, 0.0], vray[:diffuse_color])
    assert_equal([0.8, 0.8, 0.8], vray[:reflect_color])
    assert_in_delta(0.9, vray[:reflect_glossiness_float])
    assert_in_delta(1.5, vray[:refract_ior_float])
  end

  def test_values_are_clamped
    vray = Parameters.to_vray(reflection: 3, diffuse_color: [300, -5, 10])

    assert_equal([1.0, 1.0, 1.0], vray[:reflect_color])
    assert_equal([1.0, 0.0, 10 / 255.0], vray[:diffuse_color])
  end

  def test_round_trip_to_friendly_values
    friendly = Parameters.from_vray(diffuse_color: [1.0, 0.5, 0.0, 1.0], reflect_color: [0.8, 0.8, 0.8],
                                    metalness_float: 1.0)

    assert_equal({ diffuse_color: [255, 128, 0], reflection: 0.8, metalness: 1.0 }, friendly)
  end

  def test_unknown_setting_is_refused
    assert_raises(ArgumentError) { Parameters.to_vray(sparkle: 1) }
  end

end
