# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/features/layout_sheets/page_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/scale'

class LayoutSheetsScaleTest < Minitest::Test

  LayoutSheets = MuriloEduardo::VRayToolkit::Features::LayoutSheets
  Scale = LayoutSheets::Scale

  METER = 39.37

  def box(width, height)
    LayoutSheets::Box.new(x: 0, y: 0, width: width, height: height)
  end

  def test_picks_the_largest_scale_that_fits
    # 12 m x 6 m on a 15.7" x 9.8" viewport: 1:100 would need 4.7" x 2.4";
    # 1:50 needs 9.4" x 4.7" and fits within 90%.
    assert_equal(50, Scale.fit([12 * METER, 6 * METER], box(15.7, 9.8)))
  end

  def test_limited_by_the_tighter_direction
    # A tall 3 m x 30 m drawing is limited by the height: 1:125 needs 9.4"
    # of the 8.8" allowed (90% of 9.8"), so it drops to 1:200.
    assert_equal(200, Scale.fit([3 * METER, 30 * METER], box(15.7, 9.8)))
  end

  def test_small_objects_get_large_scales
    assert_equal(1, Scale.fit([5.0, 5.0], box(10, 10)))
  end

  def test_huge_extent_falls_back_to_smallest_scale
    assert_equal(5000, Scale.fit([1_000_000.0, 10.0], box(10, 10)))
  end

  def test_parse_and_label
    assert_equal(75, Scale.parse('1:75'))
    assert_equal('1:200', Scale.label(200))
  end

  def test_choices_start_with_auto_and_parse
    assert_equal('auto', Scale::CHOICES.first)
    Scale::CHOICES.drop(1).each { |choice| assert_equal(choice, Scale.label(Scale.parse(choice))) }
  end

end
