# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/html')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/report_dialog')
Sketchup.require('me_vray_toolkit/features/agent_connection/page')
Sketchup.require('me_vray_toolkit/features/agent_connection/strings')
Sketchup.require('me_vray_toolkit/mcp/service')
Sketchup.require('me_vray_toolkit/mcp/tools')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Lets an AI agent (any MCP client on this computer) use the
      # extension's actions as tools: starts the local MCP server and shows
      # how to connect.
      module AgentConnection

        # Starts the server if needed and shows the connection window.
        def self.run
          Mcp::Service.start unless Mcp::Service.running?
          show
        rescue Errno::EADDRINUSE, Errno::EACCES
          UI.messagebox(t(:port_busy, ports: "#{Mcp::Service::PORTS.first}-#{Mcp::Service::PORTS.last}"))
        end

        def self.stop
          Mcp::Service.stop
          show
        end

        def self.show
          html = Page.render(url: Mcp::Service.url, token: Mcp::Service.token, tool_count: Actions.all.size,
                             events: Events.recent('action.'))
          ReportDialog.show(key: 'agent_connection', title: t(:title), html: html)
        end

        def self.t(key, **values)
          I18n.t(STRINGS, key, **values)
        end
        private_class_method :t

        Commands.register(id: :agent_connection, title: -> { I18n.t(STRINGS, :menu_item) }, order: 5) { run }
        Commands.register(id: :agent_connection_stop, title: -> { I18n.t(STRINGS, :menu_stop) }, order: 6) { stop }

        # Keeps serving across SketchUp sessions once the user turned it on.
        # A busy port must not stop the extension from loading: the user can
        # start it from the menu, which explains the problem.
        begin
          Mcp::Service.start if Mcp::Service.autostart? && !Mcp::Service.running?
        rescue Errno::EADDRINUSE, Errno::EACCES
          nil
        end

      end
    end
  end
end
