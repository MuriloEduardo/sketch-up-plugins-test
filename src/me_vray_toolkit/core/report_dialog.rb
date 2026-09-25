# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Read-only HtmlDialog that shows a static HTML document (built with
    # {Html}). One window per key: showing it again replaces its content.
    module ReportDialog

      # Dialogs are kept referenced so they are not garbage collected while open.
      @dialogs = {}

      # @param key [String] unique per report, also remembers window size/position
      # @param title [String]
      # @param html [String] complete document
      # @return [UI::HtmlDialog]
      def self.show(key:, title:, html:)
        dialog = @dialogs[key]
        dialog = @dialogs[key] = create(key, title) if dialog.nil?
        dialog.set_html(html)
        dialog.visible? ? dialog.bring_to_front : dialog.show
        dialog
      end

      def self.create(key, title)
        UI::HtmlDialog.new(
            dialog_title: title,
            preferences_key: "me_vray_toolkit.#{key}",
            scrollable: true,
            resizable: true,
            width: 760,
            height: 600,
            min_width: 420,
            min_height: 300,
            style: UI::HtmlDialog::STYLE_DIALOG
          )
      end
      private_class_method :create

    end
  end
end
