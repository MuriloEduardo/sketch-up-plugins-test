# frozen_string_literal: true

require 'test_helper'
require 'json'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/core/actions'
require_source 'me_vray_toolkit/mcp/http'
require_source 'me_vray_toolkit/mcp/tool_listing'
require_source 'me_vray_toolkit/mcp/tool_result'
require_source 'me_vray_toolkit/mcp/protocol'
require_source 'me_vray_toolkit/mcp/endpoint'

class McpEndpointTest < Minitest::Test

  Mcp = MuriloEduardo::VRayToolkit::Mcp
  TOKEN = 'secret-token'

  def setup
    MuriloEduardo::VRayToolkit::Actions.clear
    protocol = Mcp::Protocol.new(actions: MuriloEduardo::VRayToolkit::Actions, server: { name: 't', version: '1' })
    @endpoint = Mcp::Endpoint.new(protocol: protocol, token: -> { TOKEN })
  end

  def request(body: '{"jsonrpc":"2.0","id":1,"method":"ping"}', method: 'POST', path: '/mcp', headers: {})
    headers = { 'authorization' => "Bearer #{TOKEN}" }.merge(headers)
    @endpoint.call(Mcp::Http::Request.new(http_method: method, path: path, headers: headers, body: body))
  end

  def test_post_answers_json
    status, headers, body = request

    assert_equal(200, status)
    assert_equal(Mcp::Endpoint::JSON_TYPE, headers['Content-Type'])
    assert_equal({ 'jsonrpc' => '2.0', 'id' => 1, 'result' => {} }, JSON.parse(body))
  end

  def test_initialize_starts_a_session
    _status, headers, = request(body: '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}')

    assert_match(/\A[0-9a-f-]{36}\z/, headers['Mcp-Session-Id'])
  end

  def test_notification_is_accepted_without_body
    assert_equal([202, {}, ''], request(body: '{"jsonrpc":"2.0","method":"notifications/initialized"}'))
  end

  def test_token_is_required
    assert_equal(401, request(headers: { 'authorization' => 'Bearer wrong-token!' }).first)
    assert_equal(401, request(headers: { 'authorization' => nil }).first)
  end

  def test_other_sites_are_refused
    assert_equal(403, request(headers: { 'origin' => 'https://evil.example' }).first)
    assert_equal(200, request(headers: { 'origin' => 'http://localhost:3000' }).first)
  end

  def test_only_post_on_mcp_path
    assert_equal(405, request(method: 'GET').first)
    assert_equal(404, request(path: '/other').first)
  end

end
