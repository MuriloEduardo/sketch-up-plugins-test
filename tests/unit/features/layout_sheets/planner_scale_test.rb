# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/features/layout_sheets/strings'
require_source 'me_vray_toolkit/features/layout_sheets/page_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/scale'
require_source 'me_vray_toolkit/features/layout_sheets/template_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/scene_filter'
require_source 'me_vray_toolkit/features/layout_sheets/planner'

class LayoutSheetsPlannerScaleTest < Minitest::Test

  LayoutSheets = MuriloEduardo::VRayToolkit::Features::LayoutSheets
  Planner = LayoutSheets::Planner
  I18n = MuriloEduardo::VRayToolkit::I18n
  Params = MuriloEduardo::VRayToolkit::Params

  def teardown
    I18n.locale = nil
  end

  def planner(scenes:, geometry: nil, **input)
    Planner.new(scenes: scenes, params: Params.normalize(LayoutSheets::SCHEMA, input), project: 'Casa Rosa',
                date: '25/09/2026', geometry: geometry)
  end

  def template_geometry
    frame = LayoutSheets::Box.new(x: 0.7, y: 0.5, width: 15.0, height: 10.5)
    LayoutSheets::TemplateGeometry.new(width: 16.535, height: 11.693, margins: {}, boxes: [frame])
  end

  def test_template_sheet_gets_a_caption_instead_of_a_title_block
    I18n.locale = 'pt-BR'
    sheet = planner(scenes: [PLAN.merge(description: 'Térreo')], geometry: template_geometry,
                    index_sheet: false).sheets.first

    assert_empty(sheet.boxes)
    assert_equal(['P.Planta  ·  Térreo  ·  Escala 1:50'], sheet.texts.map(&:text))
    assert_operator(sheet.viewport.y + sheet.viewport.height, :<=, sheet.texts.first.y)
  end

  def test_template_index_sheet_has_no_title_block_texts
    sheet = planner(scenes: [PLAN], geometry: template_geometry).sheets.first

    assert_equal(['Sheet Index', "01  Sheet Index\n02  P.Planta"], sheet.texts.map(&:text))
  end

  PLAN = { name: 'P.Planta', description: '', perspective: false, extent: [12 * 39.37, 6 * 39.37] }.freeze
  PERSPECTIVE = { name: '3D', description: '', perspective: true, extent: nil }.freeze

  def test_orthographic_scene_gets_automatic_scale_in_title_block
    I18n.locale = 'pt-BR'
    sheet = planner(scenes: [PLAN], index_sheet: false).sheets.first

    assert_equal(50, sheet.scale)
    assert_includes(sheet.texts.map(&:text), 'Prancha 01 / 01  ·  Escala 1:50  ·  25/09/2026')
  end

  def test_fixed_scale_overrides_automatic
    assert_equal(200, planner(scenes: [PLAN], scale: '1:200', index_sheet: false).sheets.first.scale)
  end

  def test_perspective_scene_has_no_scale
    sheet = planner(scenes: [PERSPECTIVE], scale: '1:200', index_sheet: false).sheets.first

    assert_nil(sheet.scale)
    refute(sheet.texts.any? { |text| text.text.include?('1:') })
  end

end
