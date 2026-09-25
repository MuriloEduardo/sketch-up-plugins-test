# frozen_string_literal: true

require 'test_helper'
require 'tmpdir'
require_relative '../../../tools/build/product_builder'

class ProductBuilderTest < Minitest::Test

  MANIFEST = {
    'id' => 'me_scene_audit',
    'namespace' => 'SceneAudit',
    'name' => 'Scene Audit',
    'version' => '1.2.3',
    'description' => 'Finds problems in V-Ray scenes.',
    'features' => ['scene_audit'],
  }.freeze

  def build(manifest = MANIFEST)
    Dir.mktmpdir do |output|
      registration = ProductBuilder.new(SOURCE_ROOT, manifest).build(output)
      files = Dir.glob(File.join(output, '**', '*.rb'))
      yield output, registration, files.to_h { |file| [file.delete_prefix("#{output}/"), File.read(file)] }
    end
  end

  def test_builds_registration_and_product_files
    build do |_output, registration, files|
      assert_equal('me_scene_audit.rb', File.basename(registration))
      assert_includes(files['me_scene_audit.rb'], "SketchupExtension.new('Scene Audit', 'me_scene_audit/main')")
      assert_includes(files['me_scene_audit.rb'], "EXTENSION.version     = '1.2.3'")
      assert_includes(files['me_scene_audit/product.rb'], 'FEATURES = %w[scene_audit].freeze')
    end
  end

  def test_copies_pillars_and_only_selected_features
    build do |_output, _registration, files|
      assert(files.key?('me_scene_audit/main.rb'))
      assert(files.key?('me_scene_audit/core/commands.rb'))
      assert(files.key?('me_scene_audit/vray/bridge.rb'))
      assert(files.key?('me_scene_audit/features/scene_audit/analyzer.rb'))
      refute(files.keys.any? { |path| path.include?('render_quality') })
    end
  end

  def test_rewrites_id_and_namespace_everywhere
    build do |_output, _registration, files|
      files.each do |path, content|
        refute_includes(content, 'me_vray_toolkit', path)
        refute_match(/\bVRayToolkit\b/, content, path)
      end
      assert_includes(files['me_scene_audit/main.rb'], "Sketchup.require('me_scene_audit/core/menu')")
      assert_includes(files['me_scene_audit/core/commands.rb'], 'module SceneAudit')
    end
  end

  def test_generated_ruby_compiles
    build do |_output, _registration, files|
      files.each_value { |content| RubyVM::InstructionSequence.compile(content) }
    end
  end

  def test_validation_errors
    [
      MANIFEST.merge('id' => 'SceneAudit'),
      MANIFEST.merge('id' => 'me_vray_toolkit'),
      MANIFEST.merge('namespace' => 'scene_audit'),
      MANIFEST.merge('version' => '1.0'),
      MANIFEST.merge('features' => []),
      MANIFEST.merge('features' => ['nope']),
      MANIFEST.except('description'),
    ].each do |manifest|
      assert_raises(ArgumentError, manifest.inspect) { ProductBuilder.new(SOURCE_ROOT, manifest) }
    end
  end

  def test_rejects_feature_that_depends_on_another
    Dir.mktmpdir do |source|
      features = File.join(source, 'me_vray_toolkit', 'features')
      FileUtils.mkdir_p(File.join(features, 'a'))
      FileUtils.mkdir_p(File.join(features, 'b'))
      File.write(File.join(features, 'a', 'feature.rb'), "Sketchup.require('me_vray_toolkit/features/b/feature')\n")
      File.write(File.join(features, 'b', 'feature.rb'), "# b\n")

      error = assert_raises(ArgumentError) { ProductBuilder.new(source, MANIFEST.merge('features' => ['a'])) }
      assert_includes(error.message, 'depende de outra feature: b')
    end
  end

  def test_quote_escapes_quotes_and_backslashes
    assert_equal("'It\\'s a \\\\ path'", ProductTemplates.quote("It's a \\ path"))
    assert_equal("It's a \\ path", eval(ProductTemplates.quote("It's a \\ path"))) # rubocop:disable Security/Eval
  end

  def test_feature_references
    content = "Sketchup.require('x/features/scene_audit/report')\nFeatures::RenderQuality.run"

    assert_equal(%w[scene_audit render_quality], ProductBuilder.feature_references(content))
  end

end
