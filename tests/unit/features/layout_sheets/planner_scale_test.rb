# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/features/layout_sheets/strings'
require_source 'me_vray_toolkit/features/layout_sheets/page_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/scale'
require_source 'me_vray_toolkit/features/layout_sheets/planner'

class LayoutSheetsPlannerScaleTest < Minitest::Test

  LayoutSheets = MuriloEduardo::VRayToolkit::Features::LayoutSheets
  Planner = LayoutSheets::Planner
  I18n = MuriloEduardo::VRayToolkit::I18n
  Params = MuriloEduardo::VRayToolkit::Params

  def teardown
    I18n.locale = nil
  end

  def planner(scenes:, **input)
    Planner.new(scenes: scenes, params: Params.normalize(LayoutSheets::SCHEMA, input), project: 'Casa Rosa',
                date: '25/09/2026')
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
