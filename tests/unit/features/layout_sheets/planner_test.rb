# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/features/layout_sheets/strings'
require_source 'me_vray_toolkit/features/layout_sheets/page_geometry'
require_source 'me_vray_toolkit/features/layout_sheets/scale'
require_source 'me_vray_toolkit/features/layout_sheets/planner'

class LayoutSheetsPlannerTest < Minitest::Test

  LayoutSheets = MuriloEduardo::VRayToolkit::Features::LayoutSheets
  Planner = LayoutSheets::Planner
  I18n = MuriloEduardo::VRayToolkit::I18n
  Params = MuriloEduardo::VRayToolkit::Params

  SCENES = [
    { name: 'P.Planta baixa', description: 'Térreo' },
    { name: 'E.Fachada', description: '' },
    { name: 'p.Cozinha', description: nil },
  ].freeze

  def teardown
    I18n.locale = nil
  end

  def planner(scenes: SCENES, **input)
    Planner.new(scenes: scenes, params: Params.normalize(LayoutSheets::SCHEMA, input), project: 'Casa Rosa',
                date: '25/09/2026')
  end

  def test_prefix_filter_is_case_insensitive_and_accepts_lists
    assert_equal(['P.Planta baixa', 'p.Cozinha'], planner(prefix: 'p.').scenes.map { |scene| scene[:name] })
    assert_equal(3, planner(prefix: 'P., E.').scenes.size)
    assert_equal(3, planner(prefix: ' ').scenes.size)
  end

  def test_paper_size_by_orientation
    assert_equal([16.535, 11.693], planner(paper: 'A3').paper_size)
    assert_equal([8.5, 11.0], planner(paper: 'Letter', orientation: 'portrait').paper_size)
  end

  def test_one_sheet_per_scene_after_the_index
    sheets = planner.sheets

    assert_equal(['Sheet Index', 'P.Planta baixa', 'E.Fachada', 'p.Cozinha'], sheets.map(&:name))
    assert_equal([nil, 'P.Planta baixa', 'E.Fachada', 'p.Cozinha'], sheets.map(&:scene))
  end

  def test_without_index_sheet
    sheets = planner(index_sheet: false).sheets

    assert_equal(['P.Planta baixa', 'E.Fachada', 'p.Cozinha'], sheets.map(&:name))
    assert_includes(sheets.first.texts.map(&:text), 'Sheet 01 / 03  ·  25/09/2026')
  end

  def test_no_matching_scene_gives_no_sheets
    assert_empty(planner(prefix: 'X.').sheets)
  end

  def test_title_block_texts_are_translated
    I18n.locale = 'pt-BR'
    texts = planner.sheets[1].texts.map(&:text)

    assert_equal(['Casa Rosa', 'P.Planta baixa', 'Prancha 02 / 04  ·  25/09/2026', 'Térreo'], texts)
  end

  def test_empty_description_is_not_drawn
    texts = planner.sheets[2].texts.map(&:text)

    refute_includes(texts, '')
    assert_equal(3, texts.size)
  end

  def test_viewport_and_title_block_fit_inside_margins
    width, height = planner.paper_size
    sheet = planner.sheets[1]
    viewport = sheet.viewport
    project, info = sheet.boxes

    assert_in_delta(LayoutSheets::PageGeometry::MARGIN, viewport.x)
    assert_in_delta(width - LayoutSheets::PageGeometry::MARGIN, info.x + info.width)
    assert_in_delta(height - LayoutSheets::PageGeometry::MARGIN, project.y + project.height)
    assert_operator(viewport.y + viewport.height, :<, project.y)
    assert_in_delta(project.x + project.width, info.x)
  end

  def test_index_lists_every_sheet_in_columns
    scenes = (1..60).map { |number| { name: "Cena #{number}", description: '' } }
    sheet = planner(scenes: scenes, paper: 'A4').sheets.first
    title_block_top = sheet.boxes.first.y
    heading, *columns = sheet.texts.select { |text| text.y < title_block_top }

    assert_equal('Sheet Index', heading.text)

    assert_nil(sheet.viewport)
    assert_operator(columns.size, :>, 1)
    assert_equal(61, columns.sum { |text| text.text.lines.size })
    assert(columns.first.text.start_with?('01  Sheet Index'))
  end

  def test_output_base_never_reuses_an_existing_file
    taken = ['C:/proj/Casa.layout', 'C:/proj/Casa (2).pdf']

    base = Planner.output_base('C:/proj/Casa.skp', exists: ->(path) { taken.include?(path) })

    assert_equal('C:/proj/Casa (3)', base)
  end

  def test_output_base_uses_model_name_when_free
    assert_equal('C:/proj/Casa', Planner.output_base('C:/proj/Casa.skp', exists: ->(_path) { false }))
  end

  def test_every_locale_translates_every_key
    keys = LayoutSheets::STRINGS.fetch('en').keys

    LayoutSheets::STRINGS.each do |locale, strings|
      assert_equal(keys.sort, strings.keys.sort, "#{locale} has different keys than en")
    end
  end

end
