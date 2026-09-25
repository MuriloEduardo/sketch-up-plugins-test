# frozen_string_literal: true

require 'socket'

module MuriloEduardoDev
  module DevBridge
    # Extensions › Dev Bridge (DEV ONLY): what the machine owner sees and
    # controls.
    module BridgeMenu

      # Call once per session (SketchUp menus cannot be rebuilt).
      def self.install
        config = DevBridge.config
        menu = UI.menu('Extensions').add_submenu(MENU_TITLE)
        menu.add_item('Connection Info...') { show_connection_info }
        menu.add_item('Start') { DevBridge.start }
        menu.add_item('Stop') { DevBridge.stop }
        autostart_item = menu.add_item('Start Automatically') { config.autostart = !config.autostart? }
        menu.set_validation_proc(autostart_item) { config.autostart? ? MF_CHECKED : MF_UNCHECKED }
        menu.add_item('Regenerate Token...') { regenerate_token }
        menu.add_item('Open Data Folder') { UI.openURL("file:///#{DevBridge.data_dir}") }
        menu.add_separator
        menu.add_item('Error Audit Settings...') { configure_error_audit }
        menu.add_item('Open Error Log Folder') { UI.openURL("file:///#{File.join(DevBridge.data_dir, 'errors')}") }
        menu
      end

      def self.show_connection_info
        command = connect_command
        UI.set_clipboard_data(command) if UI.respond_to?(:set_clipboard_data)
        UI.messagebox(
            "Status: #{DevBridge.server.running? ? 'running' : 'stopped'} " \
            "(127.0.0.1:#{DevBridge.config.port}, SSH tunnel only)\n" \
            "LAN addresses: #{lan_addresses.join(', ')}\n\n" \
            "Run on the development machine (copied to clipboard):\n#{command}\n\n" \
            'Keep this token private. Regenerate it to revoke access.',
            MB_MULTILINE, MENU_TITLE
          )
      end

      # Where the error audit is sent (studio platform URL + LAB_TOKEN). Empty
      # fields keep errors only in the local journal.
      def self.configure_error_audit
        config = DevBridge.config
        values = UI.inputbox(['Platform URL', 'Token'], [config.lab_url.to_s, config.lab_token.to_s],
                             "#{MENU_TITLE}: Error Audit")
        return unless values

        config.set_lab(url: values[0], token: values[1])
        Diagnostics.tick
      end

      def self.regenerate_token
        running = DevBridge.server.running?
        DevBridge.stop
        DevBridge.config.regenerate_token
        DevBridge.reset_server
        DevBridge.start if running
        show_connection_info
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
        "make su-connect SSH=\"#{user}@#{host}\" TOKEN=#{DevBridge.config.token} KEY=~/.ssh/id_ed25519_sketchup"
      end

    end
  end
end
