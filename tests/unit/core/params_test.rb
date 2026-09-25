# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/params'

class ParamsTest < Minitest::Test

  Params = MuriloEduardo::VRayToolkit::Params

  SCHEMA = {
    prefix: { type: :string, default: '' },
    paper: { type: :enum, values: %w[A4 A3], default: 'A3' },
    pdf: { type: :boolean, default: true },
    copies: { type: :integer, default: 1, range: 1..10 },
  }.freeze

  def test_missing_fields_take_defaults
    assert_equal({ prefix: '', paper: 'A3', pdf: true, copies: 1 }, Params.normalize(SCHEMA, {}))
  end

  def test_string_keys_and_values_are_coerced
    result = Params.normalize(SCHEMA, 'prefix' => ' P. ', 'paper' => 'a4', 'pdf' => 'no', 'copies' => '3')

    assert_equal({ prefix: 'P.', paper: 'A4', pdf: false, copies: 3 }, result)
  end

  def test_unknown_field_is_rejected
    error = assert_raises(ArgumentError) { Params.normalize(SCHEMA, colour: 'red') }

    assert_includes(error.message, 'colour')
  end

  def test_enum_outside_values_is_rejected
    error = assert_raises(ArgumentError) { Params.normalize(SCHEMA, paper: 'B5') }

    assert_includes(error.message, 'A4, A3')
  end

  def test_invalid_boolean_is_rejected
    assert_raises(ArgumentError) { Params.normalize(SCHEMA, pdf: 'maybe') }
  end

  def test_integer_outside_range_is_rejected
    assert_raises(ArgumentError) { Params.normalize(SCHEMA, copies: 11) }
    assert_raises(ArgumentError) { Params.normalize(SCHEMA, copies: 'two') }
  end

end
