# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/light_placement'

class LightPlacementTest < Minitest::Test

  Placement = MuriloEduardo::VRayToolkit::VRayBridge::LightPlacement

  def test_without_target_the_light_shines_down
    axes = Placement.axes([1.0, 2.0, 3.0])

    assert_equal([0.0, 0.0, 1.0], axes[:zaxis])
    assert_in_delta(39.37, axes[:origin][0], 0.01)
    assert_in_delta(118.11, axes[:origin][2], 0.01)
  end

  def test_negative_z_points_at_the_target
    axes = Placement.axes([2.0, -2.0, 1.4], [2.0, 0.0, 1.4])

    assert_equal([-0.0, -1.0, -0.0], axes[:zaxis])
  end

  def test_diagonal_target_is_normalized
    zaxis = Placement.axes([0.0, 0.0, 0.0], [3.0, 0.0, 4.0])[:zaxis]

    assert_in_delta(1.0, Math.sqrt(zaxis.sum { |value| value * value }), 1e-9)
    assert_in_delta(-0.6, zaxis[0], 1e-9)
  end

  def test_target_equal_to_position_is_refused
    assert_raises(ArgumentError) { Placement.axes([1.0, 1.0, 1.0], [1.0, 1.0, 1.0]) }
  end

  def test_inches
    assert_in_delta(39.370, Placement.inches(1.0), 0.001)
  end

end
