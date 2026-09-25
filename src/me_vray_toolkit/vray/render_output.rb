# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Where rendered images go: "<model> renders/<scene> <date time>.png"
      # next to the saved model, or the temp folder for an unsaved model.
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module RenderOutput

        # Characters Windows does not allow in file names.
        UNSAFE = %r{[<>:"/\\|?*\x00-\x1f]}
        MAX_NAME = 80

        # @param model_path [String] "" when the model was never saved
        # @param scene [String, nil]
        # @param time [Time]
        # @param temp_dir [String]
        # @return [String]
        def self.path(model_path:, scene:, time:, temp_dir:)
          model_path = model_path.to_s.tr('\\', '/')
          folder = if model_path.empty?
                     File.join(temp_dir, 'V-Ray Toolkit renders')
                   else
                     File.join(File.dirname(model_path), "#{File.basename(model_path, '.*')} renders")
                   end
          File.join(folder, "#{safe_name(scene || 'view')} #{time.strftime('%Y-%m-%d %H%M%S')}.png")
        end

        # @param name [String]
        # @return [String] usable as a file name on Windows and macOS
        def self.safe_name(name)
          cleaned = name.to_s.gsub(UNSAFE, '_').strip.sub(/[. ]+\z/, '')
          cleaned = 'view' if cleaned.empty?
          cleaned[0, MAX_NAME]
        end

      end
    end
  end
end
