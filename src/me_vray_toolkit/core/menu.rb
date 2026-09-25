# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/events')

module MuriloEduardo
  module VRayToolkit
    # Builds the product's submenu under Extensions from {Commands}.
    module Menu

      # Adds one menu item per registered command. Call once per session
      # (guarded by `file_loaded?` in main.rb): SketchUp menus cannot be rebuilt.
      #
      # @param title [String] submenu title
      # @return [Sketchup::Menu]
      def self.install(title)
        submenu = UI.menu('Extensions').add_submenu(title)
        Commands.all.each do |spec|
          id = spec.id
          submenu.add_item(spec.label) { Commands.invoke(id, on_error: method(:report_error)) }
        end
        submenu
      end

      # Shows the error and publishes "command.failed", so diagnostics
      # (e.g. the development error audit) keep it after the dialog closes.
      #
      # @param spec [Commands::Spec]
      # @param error [StandardError]
      def self.report_error(spec, error)
        Events.publish('command.failed', { command: spec.id.to_s, error_class: error.class.name,
                                           error: error.message, backtrace: Array(error.backtrace).first(50), })
        UI.messagebox("#{spec.label}\n\n#{error.class}: #{error.message}")
      end

    end
  end
end
