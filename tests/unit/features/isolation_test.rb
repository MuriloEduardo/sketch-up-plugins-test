# frozen_string_literal: true

require 'test_helper'
require_relative '../../../tools/build/product_builder'

# Features may use the platform pillars but never another feature: that is
# what lets tools/build/product_builder.rb package any combination of them.
class FeatureIsolationTest < Minitest::Test

  FEATURES_DIR = File.join(SOURCE_ROOT, 'me_vray_toolkit', 'features')

  def test_every_feature_only_references_itself
    features = Dir.children(FEATURES_DIR).sort

    refute_empty(features)
    features.each do |feature|
      Dir.glob(File.join(FEATURES_DIR, feature, '**', '*.rb')).each do |file|
        others = ProductBuilder.feature_references(File.read(file)) - [feature]

        assert_empty(others, "#{file} references other features")
      end
    end
  end

  def test_product_lists_every_feature_folder
    require_source 'me_vray_toolkit/product'

    assert_equal(Dir.children(FEATURES_DIR).sort, MuriloEduardo::VRayToolkit::Product::FEATURES.sort)
  end

end
