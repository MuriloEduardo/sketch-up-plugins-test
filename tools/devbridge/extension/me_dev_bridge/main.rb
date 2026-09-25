# frozen_string_literal: true

require 'socket'

Sketchup.require('me_dev_bridge/security')
Sketchup.require('me_dev_bridge/http')
Sketchup.require('me_dev_bridge/evaluator')
Sketchup.require('me_dev_bridge/config')
Sketchup.require('me_dev_bridge/workspace')
Sketchup.require('me_dev_bridge/routes')
Sketchup.require('me_dev_bridge/server')
Sketchup.require('me_dev_bridge/testup_runner')

module MuriloEduardoDev
  module DevBridge

    BRIDGE_VERSION = '0.1.2'
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
      }
    end

    # @return [Array<String>] private IPv4 addresses of this machine
    def self.lan_addresses
      Socket.ip_address_list.select(&:ipv4_private?).map(&:ip_address)
    end

    # @return [String] command to run on the development machine
    def self.connect_command
      host = lan_addresses.first || '<ip-desta-maquina>'
      user = ENV.fetch('USERNAME', '<usuario-windows>')
      # Quoted: Windows user names may contain spaces ("Jane Doe").
      "make su-connect SSH=\"#{user}@#{host}\" TOKEN=#{config.token} KEY=~/.ssh/id_ed25519_sketchup"
    end

    def self.start
      server.start
    rescue SystemCallError => error
      UI.messagebox("#{MENU_TITLE}: could not listen on #{config.bind}:#{config.port}.\n#{error.message}")
    end

    def self.stop
      server.stop
    end

    def self.show_connection_info
      command = connect_command
      UI.set_clipboard_data(command) if UI.respond_to?(:set_clipboard_data)
      UI.messagebox(
          "Status: #{server.running? ? 'running' : 'stopped'} (127.0.0.1:#{config.port}, SSH tunnel only)\n" \
          "LAN addresses: #{lan_addresses.join(', ')}\n\n" \
          "Run on the development machine (copied to clipboard):\n#{command}\n\n" \
          'Keep this token private. Regenerate it to revoke access.',
          MB_MULTILINE, MENU_TITLE
        )
    end

    def self.regenerate_token
      running = server.running?
      stop
      config.regenerate_token
      @server = nil
      start if running
      show_connection_info
    end

    unless file_loaded?(__FILE__)
      workspace.activate
      start if config.autostart?

      menu = UI.menu('Extensions').add_submenu(MENU_TITLE)
      menu.add_item('Connection Info...') { show_connection_info }
      menu.add_item('Start') { start }
      menu.add_item('Stop') { stop }
      autostart_item = menu.add_item('Start Automatically') { config.autostart = !config.autostart? }
      menu.set_validation_proc(autostart_item) { config.autostart? ? MF_CHECKED : MF_UNCHECKED }
      menu.add_item('Regenerate Token...') { regenerate_token }
      menu.add_item('Open Data Folder') { UI.openURL("file:///#{data_dir}") }
      file_loaded(__FILE__)
    end

  end
end
