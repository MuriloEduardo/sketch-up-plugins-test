# frozen_string_literal: true

require 'json'
require 'test_helper'
require_source 'me_vray_toolkit/mcp/relay'

class RelayTest < Minitest::Test

  Relay = MuriloEduardo::VRayToolkit::Mcp::Relay

  def setup
    @now = Time.at(1_000)
    @requests = []
    @replies = [] # [status, body] of the next polls; results always answer 200
    @handled = []
    @relay = build(post: lambda { |url, headers, body, &done|
      @requests << [url, headers, JSON.parse(body)]
      url.end_with?('/poll') ? done.call(*(@replies.shift || [200, '{"calls":[]}'])) : done.call(200, '{}')
    })
  end

  def build(post:)
    local = Relay::Local.new(handler: method(:handle), tools: -> { [{ 'name' => 'model_info' }] },
                             info: -> { { sketchup: '26.1' } })
    Relay.new(url: 'https://site.test/', token: 'lrd_x', local: local, post: post, clock: -> { @now })
  end

  def handle(json)
    message = JSON.parse(json)
    @handled << message
    raise 'boom' if message['method'] == 'explode'

    { 'jsonrpc' => '2.0', 'id' => message['id'], 'result' => { 'ok' => message['method'] } }
  end

  def polls = @requests.select { |url, *| url.end_with?('/poll') }
  def results = @requests.select { |url, *| url.end_with?('/result') }.map(&:last)

  def test_first_poll_sends_token_versions_and_tools
    @relay.tick

    url, headers, body = polls.first
    assert_equal('https://site.test/api/sketchup/poll', url)
    assert_equal('Bearer lrd_x', headers['Authorization'])
    assert_equal([{ 'name' => 'model_info' }], body['tools'])
    assert_match(/\A\h+\z/, body['tools_hash'])
    assert_equal({ 'sketchup' => '26.1' }, body['info'])
  end

  def test_tools_go_again_only_when_the_platform_asks
    @replies = [[200, '{"calls":[],"next_poll_ms":1000,"need_tools":false}'], [200, '{"calls":[],"need_tools":true}']]
    3.times do
      @relay.tick
      @now += 30
    end

    assert_equal([true, false, true], polls.map { |_url, _headers, body| body.key?('tools') })
  end

  def test_runs_each_call_and_posts_its_response
    calls = [{ id: 'c1', message: { jsonrpc: '2.0', id: 7, method: 'tools/call' } },
             { id: 'c2', message: { jsonrpc: '2.0', id: 8, method: 'explode' } },]
    @replies = [[200, JSON.generate(calls: calls, next_poll_ms: 1000)]]
    @relay.tick

    assert_equal(%w[tools/call explode], @handled.map { |message| message['method'] })
    expected = { 'jsonrpc' => '2.0', 'id' => 7, 'result' => { 'ok' => 'tools/call' } }
    assert_equal({ 'id' => 'c1', 'response' => expected }, results[0])
    assert_equal([8, 'RuntimeError: boom'], results[1]['response'].then { |r| [r['id'], r['error']['message']] })
  end

  def test_follows_the_pace_the_platform_sets
    @replies = [[200, '{"calls":[],"next_poll_ms":20000}']]
    @relay.tick
    @now += 19
    refute(@relay.tick)
    @now += 1
    assert(@relay.tick)
  end

  def test_after_calls_it_asks_again_right_away
    @replies = [[200,
                 '{"calls":[{"id":"c1","message":{"jsonrpc":"2.0","id":1,"method":"ping"}}],"next_poll_ms":20000}',]]
    @relay.tick

    assert(@relay.tick, 'more calls may be waiting')
  end

  def test_errors_back_off_and_revocation_stops
    @replies = [[500, 'oops'], [401, '{"error":"revoked"}']]
    @relay.tick
    assert_includes(@relay.last_error, 'HTTP 500')
    @now += Relay::ERROR_DELAY - 1
    refute(@relay.tick)
    @now += 1
    @relay.tick

    refute(@relay.running?)
    @now += 3600
    refute(@relay.tick)
  end

  def test_one_poll_at_a_time
    relay = build(post: ->(*) {})

    assert(relay.tick)
    refute(relay.tick, 'the answer has not arrived yet')
  end

  def test_transport_failure_is_recorded_not_raised
    relay = build(post: ->(*) { raise IOError, 'offline' })

    relay.tick
    assert_equal('IOError: offline', relay.last_error)
    @now += Relay::ERROR_DELAY
    assert(relay.tick, 'tries again after the delay')
  end

end
