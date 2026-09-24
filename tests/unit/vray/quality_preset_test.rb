# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/quality_preset'

class QualityPresetTest < Minitest::Test

  QualityPreset = MuriloEduardo::VRayToolkit::VRayBridge::QualityPreset

  def test_labels_are_ordered_from_low_to_custom
    assert_equal(%w[Low Low+ Medium Medium+ High High+ Custom], QualityPreset.labels)
  end

  def test_label_for_known_value
    assert_equal('High', QualityPreset.label_for(4))
  end

  def test_label_for_unknown_value_raises
    assert_raises(ArgumentError) { QualityPreset.label_for(7) }
  end

  def test_value_for_is_case_insensitive
    assert_equal(5, QualityPreset.value_for(' high+ '))
  end

  def test_value_for_unknown_label_raises
    assert_raises(ArgumentError) { QualityPreset.value_for('Ultra') }
  end

  def test_targets_settings_options_plugin
    assert_equal('/SettingsOptions', QualityPreset::PLUGIN_NAME)
    assert_equal(:quality_preset, QualityPreset::PARAMETER)
  end

end
