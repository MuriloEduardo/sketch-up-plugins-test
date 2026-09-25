# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/core/html'
require_source 'me_vray_toolkit/features/scene_audit/strings'
require_source 'me_vray_toolkit/features/scene_audit/analyzer'
require_source 'me_vray_toolkit/features/scene_audit/report'

class SceneAuditReportTest < Minitest::Test

  SceneAudit = MuriloEduardo::VRayToolkit::Features::SceneAudit
  I18n = MuriloEduardo::VRayToolkit::I18n

  def teardown
    I18n.locale = nil
  end

  def analyzer(materials: [], references: [])
    environment = { sketchup_version: '26.1.252', vray_version: '7.20.00', vray_api_version: '5.04.02',
                    vray_api_available: true, }
    SceneAudit::Analyzer.new(environment: environment, materials: materials, file_references: references)
  end

  def test_portuguese_report_with_findings
    I18n.locale = 'pt-BR'
    references = [{ plugin: '/Brick/Bitmap', parameter: :file, path: 'C:/tex/<brick>.jpg', exists: false }]
    html = SceneAudit::Report.render(analyzer(references: references))

    assert_includes(html, '<title>Auditoria de Cena</title>')
    assert_includes(html, '7.20.00 (API 5.04.02)')
    assert_includes(html, '<span class="error">Erro</span>')
    assert_includes(html, 'C:/tex/&lt;brick&gt;.jpg')
    assert_includes(html, 'Usado por: /Brick/Bitmap')
  end

  def test_empty_report_says_no_problems
    html = SceneAudit::Report.render(analyzer)

    assert_includes(html, 'No problems found.')
  end

  def test_every_locale_translates_every_key
    keys = SceneAudit::STRINGS.fetch('en').keys

    SceneAudit::STRINGS.each do |locale, strings|
      assert_equal(keys.sort, strings.keys.sort, "#{locale} has different keys than en")
    end
  end

end
