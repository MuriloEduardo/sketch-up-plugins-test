# frozen_string_literal: true

require 'json'

module MuriloEduardo
  module VRayToolkit
    module Features
      module AgentConnection
        # The "Connect AI agent" window: server state, token, ready-to-paste
        # configuration for common MCP clients and the latest tool calls.
        #
        # Pure Ruby (needs {I18n}, {Html} and STRINGS loaded): unit tested in
        # the Docker toolchain.
        module Page

          NAME = 'sketchup'

          class << self

            # @param url [String] MCP endpoint
            # @param token [String]
            # @return [Hash{Symbol => String}] client key => configuration text
            def snippets(url, token)
              header = "Bearer #{token}"
              {
                claude_code: "claude mcp add --transport http #{NAME} #{url} --header \"Authorization: #{header}\"",
                cursor: json(mcpServers: { NAME => { url: url, headers: { Authorization: header } } }),
                vscode: json(servers: { NAME => { type: 'http', url: url, headers: { Authorization: header } } }),
                claude_desktop: json(mcpServers: { NAME => { command: 'npx', args: remote_args(url, header) } }),
              }
            end

            # @param url [String, nil] nil when stopped
            # @param token [String]
            # @param tool_count [Integer]
            # @param events [Array<Events::Event>] "action.*", oldest first
            # @return [String] HTML document
            def render(url:, token:, tool_count:, events:)
              body = url ? running(url, token, tool_count) : "<p>#{Html.escape(t(:stopped))}</p>"
              body += "\n<h2>#{Html.escape(t(:activity))}</h2>\n#{activity(events)}"
              Html.document(title: t(:title), body: body, lang: I18n.locale)
            end

            private

            def running(url, token, tool_count)
              blocks = snippets(url, token).map do |client, text|
                "<h3>#{Html.escape(t(client))}</h3>\n<pre>#{Html.escape(text)}</pre>"
              end
              [
                "<p>#{Html.escape(t(:running, url: url))}</p>",
                "<p class=\"muted\">#{Html.escape(t(:tools, count: tool_count))}</p>",
                "<h2>#{Html.escape(t(:token))}</h2>\n<pre>#{Html.escape(token)}</pre>",
                "<h2>#{Html.escape(t(:clients))}</h2>",
                *blocks,
              ].join("\n")
            end

            def activity(events)
              return "<p class=\"muted\">#{Html.escape(t(:no_activity))}</p>" if events.empty?

              rows = events.last(20).reverse.map do |event|
                payload = event.payload
                result = event.topic == 'action.failed' ? t(:failed, error: payload[:error]) : t(:ok, ms: payload[:ms])
                [event.at.strftime('%H:%M:%S'), payload[:name], result].map { |cell| Html.escape(cell) }
              end
              Html.table([t(:col_time), t(:col_tool), t(:col_result)], rows)
            end

            # Claude Desktop starts local servers as programs; mcp-remote bridges
            # them to this HTTP endpoint.
            def remote_args(url, header)
              ['-y', 'mcp-remote', url, '--header', "Authorization:#{header}"]
            end

            def json(data)
              JSON.pretty_generate(data)
            end

            def t(key, **values)
              I18n.t(STRINGS, key, **values)
            end

          end

        end
      end
    end
  end
end
