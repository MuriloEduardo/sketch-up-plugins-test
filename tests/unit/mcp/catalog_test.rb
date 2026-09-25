# frozen_string_literal: true

require 'test_helper'
require 'yaml'

# tools/mcp/catalog.yml maps every SketchUp/LayOut/V-Ray API class to a tool
# group (or marks it internal with a reason) and lists every tool. This keeps
# "no part of the API ignored" true as the code grows.
class McpCatalogTest < Minitest::Test

  ROOT = File.expand_path('../../..', __dir__)
  CATALOG = YAML.safe_load_file(File.join(ROOT, 'tools/mcp/catalog.yml'))
  API_INDEX = File.join(ROOT, 'docs/reference/sketchup-api-index.md')

  # V-Ray for SketchUp 7.20: documented classes plus the internal ones we use
  # (docs/reference/vray-ruby-api.md, section 0).
  VRAY_CLASSES = %w[
    VRay::AColor VRay::Color VRay::Matrix VRay::Vector VRay::Transform VRay::ModelExporter VRay::Proxy
    VRay::Scene VRay::Scene::ChangeSet VRay::Scene::Plugin VRay::ScenePreview VRay::UVTextureSampler
    VRay::VRayImage VRay::VRayInit VRay::VRayRenderer VRay::VRayRenderer::Plugin VRay::GeomUtils
    VRay::Context VRay::Command VRay::BatchExporter
  ].freeze

  def api_classes
    File.read(API_INDEX).scan(/^## (\S+)/).flatten + VRAY_CLASSES
  end

  def mapped_classes
    CATALOG['groups'].values.flat_map { |group| group['classes'] } + CATALOG['internal'].keys
  end

  def catalog_tools
    CATALOG['groups'].values.flat_map { |group| group['tools'].to_a }.to_h
  end

  def registered_tools
    Dir.glob(File.join(ROOT, 'src/**/*.rb')).flat_map do |file|
      File.read(file).scan(/Actions\.register\(\s*name: '([a-z0-9_]+)'/).flatten
    end
  end

  def test_every_api_class_is_mapped
    missing = api_classes - mapped_classes

    assert_empty(missing, 'add these classes to a group or to internal in tools/mcp/catalog.yml')
  end

  def test_no_class_is_mapped_twice_or_unknown
    counts = mapped_classes.tally

    assert_empty(counts.select { |_name, count| count > 1 }.keys, 'mapped more than once')
    assert_empty(mapped_classes - api_classes, 'not in the API index')
  end

  def test_every_registered_action_is_in_the_catalog_as_done
    registered = registered_tools

    refute_empty(registered)
    registered.each { |name| assert_equal('done', catalog_tools[name], "#{name} should be done in the catalog") }
  end

  def test_every_done_tool_is_registered
    done = catalog_tools.select { |_name, status| status == 'done' }.keys

    assert_empty(done - registered_tools, 'marked done but not registered in src/')
  end

  def test_statuses_and_names_are_valid
    catalog_tools.each do |name, status|
      assert_match(/\A[a-z][a-z0-9_]{1,63}\z/, name)
      assert_includes(%w[done planned], status, name)
    end
  end

end
