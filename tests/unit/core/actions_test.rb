# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/core/actions'

class ActionsTest < Minitest::Test

  Actions = MuriloEduardo::VRayToolkit::Actions
  Events = MuriloEduardo::VRayToolkit::Events

  def setup
    Actions.clear
    Events.clear
  end

  def register_echo
    Actions.register(name: 'echo_text', group: :test, description: 'Echoes', read_only: true,
                     schema: { text: { type: :string, required: true } }) { |params| { text: params[:text] } }
  end

  def test_call_validates_input_and_returns_the_result
    register_echo

    assert_equal({ text: 'hi' }, Actions.call('echo_text', { 'text' => ' hi ' }))
    assert_raises(ArgumentError) { Actions.call('echo_text', {}) }
    assert_raises(KeyError) { Actions.call('missing') }
  end

  def test_title_defaults_to_the_name_and_read_only_is_idempotent
    action = register_echo

    assert_equal('Echo text', action.title)
    assert(action.idempotent)
  end

  def test_calls_publish_events
    register_echo

    Actions.call('echo_text', { text: 'a' }, source: 'mcp')
    assert_raises(ArgumentError) { Actions.call('echo_text', {}) }

    completed, failed = Events.recent('action.')
    assert_equal(['action.completed', 'mcp', 'echo_text'], [completed.topic, completed.payload[:source],
                                                            completed.payload[:name],])
    assert_equal('action.failed', failed.topic)
    assert_match(/text: required/, failed.payload[:error])
  end

  def test_rejects_bad_definitions
    assert_raises(ArgumentError) { Actions.register(name: 'Bad-Name', group: :x, description: 'd') { nil } }
    assert_raises(ArgumentError) { Actions.register(name: 'no_description', group: :x, description: '') { nil } }
    assert_raises(ArgumentError) { Actions.register(name: 'no_handler', group: :x, description: 'd') }
  end

end
