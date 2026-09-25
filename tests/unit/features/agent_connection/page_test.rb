# frozen_string_literal: true

require 'test_helper'
require 'json'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/core/html'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/features/agent_connection/strings'
require_source 'me_vray_toolkit/features/agent_connection/page'

class AgentConnectionPageTest < Minitest::Test

  AgentConnection = MuriloEduardo::VRayToolkit::Features::AgentConnection
  Events = MuriloEduardo::VRayToolkit::Events
  I18n = MuriloEduardo::VRayToolkit::I18n
  URL = 'http://127.0.0.1:7878/mcp'

  def teardown
    I18n.locale = nil
  end

  def test_snippets_carry_url_and_token
    snippets = AgentConnection::Page.snippets(URL, 'abc')

    assert_equal('claude mcp add --transport http sketchup http://127.0.0.1:7878/mcp ' \
                 '--header "Authorization: Bearer abc"', snippets[:claude_code])
    assert_equal({ 'url' => URL, 'headers' => { 'Authorization' => 'Bearer abc' } },
                 JSON.parse(snippets[:cursor])['mcpServers']['sketchup'])
    assert_equal('http', JSON.parse(snippets[:vscode])['servers']['sketchup']['type'])
    assert_includes(JSON.parse(snippets[:claude_desktop])['mcpServers']['sketchup']['args'], URL)
  end

  def test_running_page_shows_token_and_activity
    I18n.locale = 'pt-BR'
    events = [Events::Event.new(topic: 'action.failed', payload: { name: 'capture_view', error: '<boom>' },
                                at: Time.new(2026, 9, 25, 3, 0, 0))]

    html = AgentConnection::Page.render(url: URL, token: 'abc', tool_count: 12, events: events)

    assert_includes(html, '12 ferramentas disponíveis')
    assert_includes(html, '<pre>abc</pre>')
    assert_includes(html, 'falhou: &lt;boom&gt;')
  end

  def test_stopped_page
    html = AgentConnection::Page.render(url: nil, token: 'abc', tool_count: 0, events: [])

    assert_includes(html, 'The MCP server is stopped.')
    refute_includes(html, 'abc')
  end

  def test_every_locale_translates_every_key
    keys = AgentConnection::STRINGS.fetch('en').keys

    AgentConnection::STRINGS.each { |locale, strings| assert_equal(keys.sort, strings.keys.sort, locale) }
  end

end
