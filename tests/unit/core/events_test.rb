# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/events'

class EventsTest < Minitest::Test

  Events = MuriloEduardo::VRayToolkit::Events

  def setup
    Events.clear
  end

  def test_subscribers_receive_topics_by_prefix
    received = []
    Events.subscribe('action.') { |event| received << event.topic }

    Events.publish('action.completed', name: 'x')
    Events.publish('model.changed')

    assert_equal(['action.completed'], received)
  end

  def test_failing_subscriber_does_not_stop_others
    received = []
    Events.subscribe { raise 'boom' }
    Events.subscribe { |event| received << event.payload[:n] }

    Events.publish('x', n: 1)

    assert_equal([1], received)
    assert_equal('boom', Events.last_error.message)
  end

  def test_unsubscribe
    received = []
    id = Events.subscribe { |event| received << event }
    Events.unsubscribe(id)

    Events.publish('x')

    assert_empty(received)
  end

  def test_recent_keeps_a_bounded_history
    (Events::RECENT_LIMIT + 5).times { |index| Events.publish('tick', index: index) }

    assert_equal(Events::RECENT_LIMIT, Events.recent.size)
    assert_equal(5, Events.recent.first.payload[:index])
    assert_empty(Events.recent('other'))
  end

end
