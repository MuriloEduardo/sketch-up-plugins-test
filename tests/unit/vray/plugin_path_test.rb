# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/plugin_path'

class PluginPathTest < Minitest::Test

  PluginPath = MuriloEduardo::VRayToolkit::VRayBridge::PluginPath

  def test_join_builds_absolute_path
    assert_equal('/My Material/VRay Mtl', PluginPath.join('My Material', 'VRay Mtl'))
  end

  def test_join_rejects_segment_with_separator
    assert_raises(ArgumentError) { PluginPath.join('a/b') }
  end

  def test_join_rejects_empty_segment
    assert_raises(ArgumentError) { PluginPath.join('') }
  end

  def test_split_ignores_empty_segments
    assert_equal(%w[Parent Child], PluginPath.split('/Parent//Child/'))
  end

  def test_parent_of_nested_path
    assert_equal('/Parent', PluginPath.parent('/Parent/Child'))
  end

  def test_parent_of_top_level_path_is_nil
    assert_nil(PluginPath.parent('/SettingsOptions'))
  end

  def test_child_is_namespaced_under_parent
    assert_equal('/MyMaterialPlugin/vray', PluginPath.child('/MyMaterialPlugin', 'vray'))
  end

  def test_for_material_prefixes_separator
    assert_equal('/blue wood', PluginPath.for_material('blue wood'))
  end

end
