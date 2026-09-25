# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/features/render_notifications/messages')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Tells the user in SketchUp when a render starts and ends (notification
      # with the time and a button to open the folder) and shows its step in
      # the status bar, whoever started it (menu, agent, batch).
      module RenderNotifications

        # Shows one job event to the user.
        #
        # @param event [Events::Event]
        def self.show(event)
          job = event.payload
          text = Messages.notice(event.topic, job)
          Sketchup.status_text = text || Messages.status(job) if %w[render render_batch].include?(job[:kind])
          return unless text

          notification = UI::Notification.new(VRayToolkit::EXTENSION, text)
          folder = job.dig(:result, :path) && File.dirname(job[:result][:path])
          if folder
            notification.on_accept(I18n.t(STRINGS, :open_folder)) { UI.openURL("file:///#{folder}") }
          end
          notification.show
        end

        # One subscription per session, kept across development reloads.
        @subscription ||= Events.subscribe('job.') { |event| show(event) }

      end
    end
  end
end
