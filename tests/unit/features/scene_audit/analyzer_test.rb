# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/features/scene_audit/analyzer'

class SceneAuditAnalyzerTest < Minitest::Test

  Analyzer = MuriloEduardo::VRayToolkit::Features::SceneAudit::Analyzer

  VRAY_ENV = { sketchup_version: '26.1.252', vray_api_available: true }.freeze

  def material(name, uses: 1, file: nil, width: nil, height: nil)
    { name: name, display_name: name, uses: uses, texture_file: file, texture_width: width, texture_height: height }
  end

  def test_clean_model_has_no_findings
    analyzer = Analyzer.new(environment: VRAY_ENV,
                            materials: [material('Wood', file: 'wood.jpg', width: 1024,
                                                         height: 1024)])

    assert_empty(analyzer.findings)
  end

  def test_missing_files_are_grouped_by_path
    references = [
      { plugin: '/Brick/Bitmap', parameter: :file, path: 'C:/tex/brick.jpg', exists: false },
      { plugin: '/Wall/Bitmap', parameter: :file, path: 'C:/tex/brick.jpg', exists: false },
      { plugin: '/Wood/Bitmap', parameter: :file, path: 'C:/tex/wood.jpg', exists: true },
    ]
    findings = Analyzer.new(environment: VRAY_ENV, materials: [], file_references: references).findings

    assert_equal(1, findings.size)
    assert_equal(:error, findings.first.severity)
    assert_equal('C:/tex/brick.jpg', findings.first.subject)
    assert_equal({ plugins: '/Brick/Bitmap, /Wall/Bitmap' }, findings.first.params)
  end

  def test_heavy_texture_uses_largest_side
    materials = [material('Big', file: 'big.png', width: 8192, height: 2048),
                 material('Edge', file: 'e.png', width: 4096, height: 4096),]
    findings = Analyzer.new(environment: VRAY_ENV, materials: materials).findings

    assert_equal([[:warning, :heavy_texture, 'Big']], findings.map { |f| [f.severity, f.code, f.subject] })
    assert_equal({ width: 8192, height: 2048, limit: 4096 }, findings.first.params)
  end

  def test_unused_materials_are_info
    findings = Analyzer.new(environment: VRAY_ENV, materials: [material('Spare', uses: 0)]).findings

    assert_equal([[:info, :unused_material, 'Spare']], findings.map { |f| [f.severity, f.code, f.subject] })
  end

  def test_vray_missing_is_reported
    findings = Analyzer.new(environment: { vray_api_available: false }, materials: []).findings

    assert_equal([:vray_unavailable], findings.map(&:code))
  end

  def test_findings_sorted_by_severity
    references = [{ plugin: '/X', parameter: :file, path: 'x.jpg', exists: false }]
    materials = [material('Spare', uses: 0), material('Big', width: 5000, height: 10)]
    findings = Analyzer.new(environment: VRAY_ENV, materials: materials, file_references: references).findings

    assert_equal(%i[error warning info], findings.map(&:severity))
  end

  def test_summary
    references = [
      { plugin: '/A', parameter: :file, path: 'a.jpg', exists: true },
      { plugin: '/B', parameter: :file, path: 'a.jpg', exists: true },
      { plugin: '/C', parameter: :file, path: 'c.jpg', exists: false },
    ]
    materials = [material('Wood', file: 'w.jpg', width: 10, height: 10), material('Spare', uses: 0)]
    summary = Analyzer.new(environment: VRAY_ENV, materials: materials, file_references: references,
                           plugin_counts: { material: 3, light: 1, settings: 30 }).summary

    assert_equal({ materials: 2, textured_materials: 1, unused_materials: 1, vray_materials: 3, vray_lights: 1,
                   file_references: 2, missing_files: 1, }, summary)
  end

end
