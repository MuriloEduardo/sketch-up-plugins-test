# frozen_string_literal: true

require 'net/http'
require 'test_helper'
require_devbridge 'security', 'http', 'evaluator', 'routes', 'server'

# Exercises the real TCP server on loopback, with the SketchUp timer replaced
# by manual ticks.
class DevBridgeServerTest < Minitest::Test

  DevBridge = MuriloEduardoDev::DevBridge
  TOKEN = 't' * 48

  # Simulates reloading extension code that fails to load.
  class FailingWorkspace
    def reload
      raise LoadError, 'cannot load such file -- sketchup'
    end
  end

  def setup
    @port = free_port
    routes = DevBridge::Routes.new(
        token: TOKEN,
        workspace: FailingWorkspace.new,
        info: -> { { sketchup_version: 'fake' } },
        test_runner: ->(_filter) { { ok: true } }
      )
    @server = DevBridge::Server.new(
        bind: '127.0.0.1', port: @port, routes: routes,
        start_timer: ->(_interval, &block) { @tick = block },
        stop_timer: ->(_timer) {}
      )
    @server.start
  end

  def teardown
    @server.stop
  end

  def test_ping_with_valid_token
    status, body = call(Net::HTTP::Get.new('/ping'))

    assert_equal(200, status)
    assert_equal('fake', body['sketchup_version'])
  end

  def test_rejects_invalid_token
    status, = call(Net::HTTP::Get.new('/ping'), token: 'wrong')

    assert_equal(401, status)
  end

  def test_eval_returns_result
    request = Net::HTTP::Post.new('/eval')
    request.body = '6 * 7'

    _, body = call(request)

    assert_equal('42', body['result'])
  end

  def test_script_errors_become_server_errors
    request = Net::HTTP::Post.new('/reload')

    status, body = call(request)

    assert_equal(500, status)
    assert_equal('LoadError', body['error'])
  end

  def test_unknown_route_is_not_found
    status, = call(Net::HTTP::Get.new('/nope'))

    assert_equal(404, status)
  end

  private

  def call(request, token: TOKEN)
    request['X-Dev-Token'] = token
    response = nil
    client = Thread.new { response = Net::HTTP.start('127.0.0.1', @port) { |http| http.request(request) } }
    100.times do
      @tick.call
      break unless client.alive?

      sleep(0.02)
    end
    client.join(5)
    [response.code.to_i, JSON.parse(response.body)]
  end

  def free_port
    socket = TCPServer.new('127.0.0.1', 0)
    socket.addr[1]
  ensure
    socket&.close
  end

end
