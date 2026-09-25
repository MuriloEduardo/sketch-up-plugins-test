# frozen_string_literal: true

require 'test_helper'
require 'socket'
require_source 'me_vray_toolkit/mcp/http'
require_source 'me_vray_toolkit/mcp/server'

class McpServerTest < Minitest::Test

  Mcp = MuriloEduardo::VRayToolkit::Mcp

  def setup
    endpoint = ->(request) { [200, { 'Content-Type' => 'text/plain' }, "#{request.http_method} #{request.body}"] }
    @server = Mcp::Server.new(endpoint: endpoint, start_timer: ->(_interval, &_block) { :timer },
                              stop_timer: ->(_id) {})
  end

  def teardown
    @server.stop
  end

  def exchange(raw)
    socket = TCPSocket.new(Mcp::Server::BIND, @server.port)
    socket.write(raw)
    @server.tick until socket.wait_readable(0.01)
    socket.read
  ensure
    socket&.close
  end

  def test_serves_a_post_on_the_first_free_port
    port = @server.start(0..0)

    response = exchange("POST /mcp HTTP/1.1\r\nContent-Length: 4\r\n\r\nping")

    assert_operator(port, :>, 0)
    assert_match(%r{\AHTTP/1.1 200 OK}, response)
    assert(response.end_with?("\r\n\r\nPOST ping"))
  end

  def test_bad_requests_are_refused
    @server.start(0..0)

    assert_match(%r{\AHTTP/1.1 400}, exchange("garbage\r\n\r\n"))
  end

  def test_busy_port_moves_to_the_next
    blocker = TCPServer.new(Mcp::Server::BIND, 0)
    taken = blocker.addr[1]

    port = @server.start([taken, 0])

    refute_equal(taken, port)
  ensure
    blocker&.close
  end

end
