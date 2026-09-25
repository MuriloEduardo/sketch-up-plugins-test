# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/params'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/core/actions'
require_source 'me_vray_toolkit/mcp/prompts'
require_source 'me_vray_toolkit/mcp/tool_listing'
require_source 'me_vray_toolkit/mcp/tool_result'
require_source 'me_vray_toolkit/mcp/protocol'

class McpPromptsTest < Minitest::Test

  Mcp = MuriloEduardo::VRayToolkit::Mcp

  def setup
    Mcp::Prompts.clear
    Mcp::Prompts.register(name: 'render_setup', description: 'Renders a scene',
                          arguments: [{ name: 'scene', description: 'Scene', required: true },
                                      { name: 'quality', description: 'Quality' },]) do |args|
      "Render #{args['scene']} at #{args['quality'] || 'the model quality'}"
    end
    @protocol = Mcp::Protocol.new(actions: MuriloEduardo::VRayToolkit::Actions, server: { name: 't', version: '1' },
                                  prompts: Mcp::Prompts)
  end

  def call(method, params = {})
    @protocol.handle('jsonrpc' => '2.0', 'id' => 1, 'method' => method, 'params' => params)
  end

  def test_initialize_announces_prompts
    assert(call('initialize')['result']['capabilities'].key?('prompts'))
  end

  def test_list_describes_arguments
    prompt = call('prompts/list')['result']['prompts'].first

    assert_equal('render_setup', prompt['name'])
    assert_equal('Render setup', prompt['title'])
    assert_equal([true, false], prompt['arguments'].map { |argument| argument['required'] })
  end

  def test_get_fills_the_message
    result = call('prompts/get', 'name' => 'render_setup', 'arguments' => { 'scene' => 'P.Planta' })['result']

    assert_equal('Renders a scene', result['description'])
    text = 'Render P.Planta at the model quality'
    assert_equal({ 'role' => 'user', 'content' => { 'type' => 'text', 'text' => text } }, result['messages'].first)
  end

  def test_missing_argument_and_unknown_prompt_are_invalid_params
    missing = call('prompts/get', 'name' => 'render_setup')['error']
    unknown = call('prompts/get', 'name' => 'nope')['error']

    assert_equal(Mcp::Protocol::INVALID_PARAMS, missing['code'])
    assert_match(/scene/, missing['message'])
    assert_equal(Mcp::Protocol::INVALID_PARAMS, unknown['code'])
  end

end
