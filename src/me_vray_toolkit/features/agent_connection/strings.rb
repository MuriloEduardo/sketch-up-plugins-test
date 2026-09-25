# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module AgentConnection

        # Translations for {I18n.t}.
        STRINGS = {
          'en' => {
            menu_item: 'Connect AI Agent (MCP)...',
            menu_stop: 'Stop AI Agent Server',
            title: 'Connect AI Agent',
            running: 'The MCP server is running at %{url}. Only programs on this computer can reach it, and ' \
                     'only with the token below.',
            stopped: 'The MCP server is stopped.',
            token: 'Token (keep it private)',
            clients: 'Add it to your AI client',
            claude_code: 'Claude Code (terminal)',
            cursor: 'Cursor (~/.cursor/mcp.json)',
            vscode: 'VS Code (.vscode/mcp.json)',
            claude_desktop: 'Claude Desktop (claude_desktop_config.json, needs Node.js)',
            activity: 'Recent agent activity',
            no_activity: 'No tool calls yet.',
            tools: '%{count} tools available',
            col_time: 'Time',
            col_tool: 'Tool',
            col_result: 'Result',
            ok: 'ok (%{ms} ms)',
            failed: 'failed: %{error}',
            port_busy: 'Could not start the MCP server: ports %{ports} are in use.',
          },
          'pt-BR' => {
            menu_item: 'Conectar Agente de IA (MCP)...',
            menu_stop: 'Parar Servidor do Agente de IA',
            title: 'Conectar Agente de IA',
            running: 'O servidor MCP está ligado em %{url}. Só programas deste computador conseguem acessá-lo, ' \
                     'e só com o token abaixo.',
            stopped: 'O servidor MCP está desligado.',
            token: 'Token (mantenha em sigilo)',
            clients: 'Adicione ao seu cliente de IA',
            claude_code: 'Claude Code (terminal)',
            cursor: 'Cursor (~/.cursor/mcp.json)',
            vscode: 'VS Code (.vscode/mcp.json)',
            claude_desktop: 'Claude Desktop (claude_desktop_config.json, exige Node.js)',
            activity: 'Atividade recente do agente',
            no_activity: 'Nenhuma ferramenta chamada ainda.',
            tools: '%{count} ferramentas disponíveis',
            col_time: 'Hora',
            col_tool: 'Ferramenta',
            col_result: 'Resultado',
            ok: 'ok (%{ms} ms)',
            failed: 'falhou: %{error}',
            port_busy: 'Não foi possível ligar o servidor MCP: as portas %{ports} estão em uso.',
          },
          'es' => {
            menu_item: 'Conectar Agente de IA (MCP)...',
            menu_stop: 'Detener Servidor del Agente de IA',
            title: 'Conectar Agente de IA',
            running: 'El servidor MCP está activo en %{url}. Solo los programas de este equipo pueden acceder, ' \
                     'y solo con el token de abajo.',
            stopped: 'El servidor MCP está detenido.',
            token: 'Token (manténgalo en privado)',
            clients: 'Agréguelo a su cliente de IA',
            claude_code: 'Claude Code (terminal)',
            cursor: 'Cursor (~/.cursor/mcp.json)',
            vscode: 'VS Code (.vscode/mcp.json)',
            claude_desktop: 'Claude Desktop (claude_desktop_config.json, requiere Node.js)',
            activity: 'Actividad reciente del agente',
            no_activity: 'Todavía no se llamó ninguna herramienta.',
            tools: '%{count} herramientas disponibles',
            col_time: 'Hora',
            col_tool: 'Herramienta',
            col_result: 'Resultado',
            ok: 'ok (%{ms} ms)',
            failed: 'falló: %{error}',
            port_busy: 'No se pudo iniciar el servidor MCP: los puertos %{ports} están en uso.',
          },
        }.freeze

      end
    end
  end
end
