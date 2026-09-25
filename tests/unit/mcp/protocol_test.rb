# frozen_string_literal: true

require 'test_helper'
require 'json'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/core/actions'
require_source 'me_vray_toolkit/mcp/tool_listing'
require_source 'me_vray_toolkit/mcp/tool_result'
require_source 'me_vray_toolkit/mcp/protocol'

class McpProtocolTest < Minitest::Test

  Actions = MuriloEduardo::VRayToolkit::Actions
  Protocol = MuriloEduardo::VRayToolkit::Mcp::Protocol

  def setup
    Actions.clear
    Actions.register(name: 'list_scenes', group: :scenes, description: 'Scenes', read_only: true) do
      { scenes: [{ name: 'P.Planta' }] }
    end
    Actions.register(name: 'capture_view', group: :vision, description: 'Picture', read_only: true,
                     schema: { width: { type: :integer, default: 800 } }) do |params|
      { width: params[:width], image: { data: 'iVBOR', mime_type: 'image/png' } }
    end
    Actions.register(name: 'erase_all', group: :model, description: 'Erases', destructive: true) { raise 'no model' }
    @protocol = Protocol.new(actions: Actions, server: { name: 'test', version: '1.2.3' },
                             instructions: 'Use model_info.')
  end

  def request(method, params = nil)
    message = { 'jsonrpc' => '2.0', 'id' => 1, 'method' => method }
    message['params'] = params if params
    @protocol.handle(message)
  end

  def test_initialize_negotiates_the_protocol_version
    result = request('initialize', 'protocolVersion' => '2025-06-18', 'capabilities' => {})['result']

    assert_equal('2025-06-18', result['protocolVersion'])
    assert_equal({ 'name' => 'test', 'version' => '1.2.3' }, result['serverInfo'])
    assert_equal('Use model_info.', result['instructions'])
    assert(result['capabilities'].key?('tools'))
  end

  def test_unknown_version_gets_the_newest
    result = request('initialize', 'protocolVersion' => '1999-01-01')['result']

    assert_equal(Protocol::SUPPORTED_VERSIONS.first, result['protocolVersion'])
  end

  def test_notifications_get_no_answer
    assert_nil(@protocol.handle('jsonrpc' => '2.0', 'method' => 'notifications/initialized'))
  end

  def test_tools_list_describes_schema_and_hints
    tools = request('tools/list')['result']['tools']
    erase = tools.find { |tool| tool['name'] == 'erase_all' }

    assert_equal(%w[erase_all list_scenes capture_view], tools.map { |tool| tool['name'] })
    assert(erase['annotations']['destructiveHint'])
    refute(erase['annotations']['readOnlyHint'])
    assert_equal('object', erase['inputSchema']['type'])
  end

  def test_tools_call_returns_text_and_structured_content
    result = request('tools/call', 'name' => 'list_scenes', 'arguments' => {})['result']

    refute(result['isError'])
    assert_equal({ scenes: [{ name: 'P.Planta' }] }, result['structuredContent'])
    assert_equal({ 'scenes' => [{ 'name' => 'P.Planta' }] }, JSON.parse(result['content'].first['text']))
  end

  def test_images_become_image_content
    result = request('tools/call', 'name' => 'capture_view', 'arguments' => { 'width' => 640 })['result']

    assert_equal({ width: 640 }, result['structuredContent'])
    assert_equal({ 'type' => 'image', 'data' => 'iVBOR', 'mimeType' => 'image/png' }, result['content'].last)
  end

  def test_tool_failures_are_reported_to_the_agent
    invalid = request('tools/call', 'name' => 'capture_view', 'arguments' => { 'width' => 'wide' })['result']
    failed = request('tools/call', 'name' => 'erase_all')['result']

    assert(invalid['isError'])
    assert_match(/Invalid arguments: width/, invalid['content'].first['text'])
    assert(failed['isError'])
    assert_equal('RuntimeError: no model', failed['content'].first['text'])
  end

  def test_unknown_tool_and_method_are_protocol_errors
    assert_equal(Protocol::INVALID_PARAMS, request('tools/call', 'name' => 'nope')['error']['code'])
    assert_equal(Protocol::METHOD_NOT_FOUND, request('sampling/createMessage')['error']['code'])
  end

  def test_disabled_groups_are_hidden
    protocol = Protocol.new(actions: Actions, server: { name: 't', version: '1' }, enabled: lambda(&:read_only))
    names = protocol.handle('jsonrpc' => '2.0', 'id' => 1, 'method' => 'tools/list')['result']['tools']
                    .map { |tool| tool['name'] }

    refute_includes(names, 'erase_all')
  end

  def test_parse_errors_and_batches
    assert_equal(Protocol::PARSE_ERROR, @protocol.handle_json('{nope')['error']['code'])
    batch = @protocol.handle_json(JSON.generate([
                                                  { jsonrpc: '2.0', id: 1, method: 'ping' },
                                                  { jsonrpc: '2.0', method: 'notifications/initialized' },
                                                ]))

    assert_equal([{ 'jsonrpc' => '2.0', 'id' => 1, 'result' => {} }], batch)
  end

end
