# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/features/layout_sheets/page_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/template_geometry'

class LayoutSheetsTemplateGeometryTest < Minitest::Test

  LayoutSheets = MuriloEduardo::VRayToolkit::Features::LayoutSheets
  TemplateGeometry = LayoutSheets::TemplateGeometry

  A3 = [16.535, 11.693].freeze
  MARGINS = { left: 0.63, top: 0.39, right: 0.39, bottom: 0.39 }.freeze

  def boxes(*rows)
    rows.map { |x, y, width, height| LayoutSheets::Box.new(x: x, y: y, width: width, height: height) }
  end

  def geometry(boxes)
    TemplateGeometry.new(width: A3[0], height: A3[1], margins: MARGINS, boxes: boxes)
  end

  # Measured on SketchUp 2026's "Titleblock/Contemporary/A3 Landscape" inside
  # page: frame, a title strip along the bottom, separators and a vertical
  # label at the right edge.
  CONTEMPORARY = [
    [2.48, 10.98, 13.11, 0.24], [0.71, 0.47, 15.35, 10.75], [0.71, 10.98, 15.35, 0.0],
    [12.55, 10.98, 2.92, 0.24], [12.52, 11.04, 0.0, 0.12], [0.71, 10.98, 1.77, 0.24],
    [15.83, 10.98, 0.0, 0.24], [15.59, 10.98, 0.0, 0.24], [2.48, 10.98, 0.0, 0.24],
    [7.68, 10.98, 4.81, 0.24], [15.83, 5.08, 0.24, 1.3], [15.81, 10.98, 0.28, 0.24],
    [15.59, 10.98, 0.24, 0.24],
  ].freeze

  def test_drawing_area_stays_inside_the_frame_above_the_title_strip
    area = geometry(boxes(*CONTEMPORARY)).drawing_area

    assert_in_delta(0.71 + TemplateGeometry::PADDING, area.x)
    assert_in_delta(0.47 + TemplateGeometry::PADDING, area.y)
    assert_in_delta(10.98 - TemplateGeometry::PADDING, area.y + area.height)
    assert_in_delta(15.83 - TemplateGeometry::PADDING, area.x + area.width)
  end

  def test_title_block_outside_the_frame_leaves_the_whole_frame
    # "Modern": labels in a column right of the frame.
    modern = boxes([0.71, 0.47, 15.12, 10.75], [15.93, 7.79, 0.15, 3.22], [15.92, 0.47, 0.15, 6.91])
    area = geometry(modern).drawing_area

    assert_in_delta(15.12 - (2 * TemplateGeometry::PADDING), area.width)
    assert_in_delta(10.75 - (2 * TemplateGeometry::PADDING), area.height)
  end

  def test_without_frame_uses_margins_and_avoids_the_title_block
    title_block = boxes([11.0, 9.0, 5.0, 2.3])
    area = geometry(title_block).drawing_area

    # Full width above the block (15.5 x 8.6) beats the column left of it (10.4 x 10.9).
    assert_in_delta(MARGINS[:left] + TemplateGeometry::PADDING, area.x)
    assert_in_delta(9.0 - TemplateGeometry::PADDING, area.y + area.height)
    assert_in_delta(A3[0] - MARGINS[:right] - TemplateGeometry::PADDING, area.x + area.width)
  end

  def test_template_draws_its_own_title_block
    assert_empty(geometry(boxes(*CONTEMPORARY)).title_block)
    assert_equal(A3, [geometry([]).width, geometry([]).height])
  end

end
