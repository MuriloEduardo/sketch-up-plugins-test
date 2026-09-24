# frozen_string_literal: true

require 'test_helper'
require_devbridge 'evaluator'

class DevBridgeEvaluatorTest < Minitest::Test

  Evaluator = MuriloEduardoDev::DevBridge::Evaluator

  def test_returns_inspected_value_and_stdout
    result = Evaluator.run('puts "hi"; [1, 2]', name: 'test')

    assert(result[:ok])
    assert_equal('[1, 2]', result[:result])
    assert_equal("hi\n", result[:stdout])
  end

  def test_json_mode_returns_raw_value
    result = Evaluator.run('{ "a" => 1 }', name: 'test', json: true)

    assert_equal({ 'a' => 1 }, result[:result])
  end

  def test_reports_exceptions
    result = Evaluator.run('raise ArgumentError, "boom"', name: 'test')

    refute(result[:ok])
    assert_equal('ArgumentError', result[:error])
    assert_equal('boom', result[:message])
  end

  def test_reports_syntax_errors
    result = Evaluator.run('def (', name: 'test')

    assert_equal('SyntaxError', result[:error])
  end

  def test_evaluations_do_not_share_local_variables
    Evaluator.run('secret = 1', name: 'test')

    assert_equal('nil', Evaluator.run('defined?(secret)', name: 'test')[:result])
  end

  def test_restores_stdout
    original = $stdout

    Evaluator.run('raise "x"', name: 'test')

    assert_same(original, $stdout)
  end

end
