# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/commands'

class CommandsTest < Minitest::Test

  Commands = MuriloEduardo::VRayToolkit::Commands

  def setup
    Commands.clear
  end

  def teardown
    Commands.clear
  end

  def test_all_is_sorted_by_order_then_id
    Commands.register(id: :b, title: 'B', order: 20) { :b }
    Commands.register(id: :c, title: 'C', order: 10) { :c }
    Commands.register(id: :a, title: 'A', order: 20) { :a }

    assert_equal(%i[c a b], Commands.all.map(&:id))
  end

  def test_register_replaces_existing_id
    Commands.register(id: :audit, title: 'Old') { :old }
    Commands.register(id: :audit, title: 'New') { :new }

    assert_equal(1, Commands.all.size)
    assert_equal(:new, Commands.invoke(:audit, on_error: ->(*) {}))
  end

  def test_label_calls_callable_title
    Commands.register(id: :audit, title: -> { 'Translated' }) { nil }

    assert_equal('Translated', Commands[:audit].label)
  end

  def test_register_validates_arguments
    assert_raises(ArgumentError) { Commands.register(id: 'audit', title: 'A') { nil } }
    assert_raises(ArgumentError) { Commands.register(id: :audit, title: '') { nil } }
    assert_raises(ArgumentError) { Commands.register(id: :audit, title: 'A') }
  end

  def test_invoke_passes_errors_to_handler_and_keeps_last_error
    Commands.register(id: :broken, title: 'Broken') { raise KeyError, 'boom' }
    reported = nil

    result = Commands.invoke(:broken, on_error: ->(spec, error) { reported = [spec.id, error.message] })

    assert_nil(result)
    assert_equal([:broken, 'boom'], reported)
    assert_instance_of(KeyError, Commands.last_error)
  end

  def test_invoke_unknown_command_raises
    assert_raises(KeyError) { Commands.invoke(:missing, on_error: ->(*) {}) }
  end

end
