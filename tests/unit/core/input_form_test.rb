# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/input_form'
require_source 'me_vray_toolkit/core/params'

class InputFormTest < Minitest::Test

  InputForm = MuriloEduardo::VRayToolkit::InputForm

  SCHEMA = {
    prefix: { type: :string, default: '' },
    orientation: { type: :enum, values: %w[landscape portrait], default: 'landscape' },
    pdf: { type: :boolean, default: true },
  }.freeze

  LABELS = { 'landscape' => 'Paisagem', 'portrait' => 'Retrato', true => 'Sim', false => 'Não' }.freeze

  def form
    InputForm.new(SCHEMA, label: ->(name) { "Prompt #{name}" }, option_label: ->(_name, value) { LABELS[value] })
  end

  def test_prompts_follow_schema_order
    assert_equal(['Prompt prefix', 'Prompt orientation', 'Prompt pdf'], form.prompts)
  end

  def test_lists_use_translated_options
    assert_equal(['', 'Paisagem|Retrato', 'Sim|Não'], form.lists)
  end

  def test_defaults_come_from_schema_or_given_values
    assert_equal(['', 'Paisagem', 'Sim'], form.defaults)
    assert_equal(['P.', 'Retrato', 'Não'], form.defaults(prefix: 'P.', orientation: 'portrait', pdf: false))
  end

  def test_parse_maps_labels_back_to_values
    input = form.parse(['E.', 'Retrato', 'Não'])

    assert_equal({ prefix: 'E.', orientation: 'portrait', pdf: false }, input)
    assert_equal(input, MuriloEduardo::VRayToolkit::Params.normalize(SCHEMA, input))
  end

end
