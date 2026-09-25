# frozen_string_literal: true

Sketchup.require('me_dev_bridge/security')
Sketchup.require('me_dev_bridge/http')
Sketchup.require('me_dev_bridge/evaluator')
Sketchup.require('me_dev_bridge/config')
Sketchup.require('me_dev_bridge/workspace')
Sketchup.require('me_dev_bridge/routes')
Sketchup.require('me_dev_bridge/server')
Sketchup.require('me_dev_bridge/testup_runner')
Sketchup.require('me_dev_bridge/error_journal')
Sketchup.require('me_dev_bridge/console_parser')
Sketchup.require('me_dev_bridge/session_markers')
Sketchup.require('me_dev_bridge/port_owner')
Sketchup.require('me_dev_bridge/error_uploader')
Sketchup.require('me_dev_bridge/toolkit_errors')
Sketchup.require('me_dev_bridge/error_context')
Sketchup.require('me_dev_bridge/console_tap')
Sketchup.require('me_dev_bridge/diagnostics')
Sketchup.require('me_dev_bridge/menu')

module MuriloEduardoDev
  module DevBridge

    BRIDGE_VERSION = '0.2.0'
    MENU_TITLE = 'Dev Bridge (DEV ONLY)'

    # @return [String] %APPDATA%/MuriloEduardoDev
    def self.data_dir
      File.expand_path(File.join(ENV.fetch('APPDATA') { Dir.home }, 'MuriloEduardoDev'))
    end

    def self.config
      @config ||= Config.new(File.join(data_dir, 'config.json'))
    end

    def self.workspace
      @workspace ||= Workspace.new(File.join(data_dir, 'workspace'))
    end

    def self.server
      @server ||= Server.new(
          bind: config.bind,
          port: config.port,
          routes: build_routes,
          start_timer: ->(interval, &block) { UI.start_timer(interval, true, &block) },
          stop_timer: ->(timer) { UI.stop_timer(timer) }
        )
    end

    def self.build_routes
      Routes.new(
          token: config.token,
          workspace: workspace,
          info: -> { environment_info },
          test_runner: ->(filter) { TestupRunner.run(workspace.root, filter) }
        )
    end

    # @return [Hash]
    def self.environment_info
      model = Sketchup.active_model
      vray = Sketchup.extensions.find { |extension| extension.name =~ /V-Ray/i }
      {
        bridge_version: BRIDGE_VERSION,
        sketchup_version: Sketchup.version,
        ruby_version: RUBY_VERSION,
        platform: Sketchup.platform.to_s,
        model_title: model&.title,
        model_path: model&.path,
        workspace: workspace.root,
        vray_version: vray&.version,
        vray_api_available: defined?(::VRay::Context) ? true : false,
        testup_available: defined?(::TestUp::API) ? true : false,
        diagnostics: Diagnostics.summary,
      }
    end

    # Starts the server. A failure is recorded in the error audit with the
    # process holding the port, and explained to the user.
    #
    # @param interactive [Boolean] false at SketchUp startup: the dialog then
    #   waits until SketchUp finished loading
    def self.start(interactive: true)
      server.start
    rescue StandardError => error
      owner = error.is_a?(Errno::EADDRINUSE) ? PortOwner.lookup(config.port) : nil
      Diagnostics.record_exception(error, source: 'bridge', context: { action: 'start', port: config.port,
                                                                       interactive: interactive, port_owner: owner, })
      message = PortOwner.explain(error, owner, "#{config.bind}:#{config.port}")
      return UI.messagebox(message, MB_MULTILINE, MENU_TITLE) if interactive

      UI.start_timer(1, false) { UI.messagebox(message, MB_MULTILINE, MENU_TITLE) }
    end

    def self.stop
      server.stop
    end

    # A new token means a new server (the routes hold the token).
    def self.reset_server
      @server = nil
    end

    unless file_loaded?(__FILE__)
      # Diagnostics first, so anything that fails below is recorded.
      Diagnostics.install(data_dir: data_dir, config: config)
      # Extensions under development must not keep the bridge from starting.
      begin
        workspace.activate
      rescue StandardError, ScriptError => error
        Diagnostics.record_exception(error, source: 'bridge', context: { action: 'workspace.activate' })
        warn("[Dev Bridge] workspace failed to load: #{error.class}: #{error.message}")
      end
      Diagnostics.watch_toolkit
      start(interactive: false) if config.autostart?
      BridgeMenu.install
      file_loaded(__FILE__)
    end

  end
end
