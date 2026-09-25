# frozen_string_literal: true

require 'base64'

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Tools that let the agent see the model.
        module Vision

          extend Support

          # @return [String] base64 PNG of the current view
          def self.capture(width, height)
            # Random.urandom, not SecureRandom: OpenSSL can freeze SketchUp on Windows.
            path = File.join(Sketchup.temp_dir, "me_vray_toolkit_view_#{Random.urandom(6).unpack1('H*')}.png")
            model.active_view.write_image(filename: path, width: width, height: height, antialias: true,
                                          transparent: false)
            Base64.strict_encode64(File.binread(path))
          ensure
            File.delete(path) if path && File.exist?(path)
          end

          Actions.register(
              name: 'capture_view', group: :vision, read_only: true,
              description: 'A PNG picture of the current SketchUp view, to see the model or check a change.',
              schema: {
                width: { type: :integer, default: 1024, range: 256..2048, description: 'Width in pixels' },
                height: { type: :integer, default: 640, range: 256..2048, description: 'Height in pixels' },
              }
            ) do |params|
            { width: params[:width], height: params[:height],
              image: { data: capture(params[:width], params[:height]), mime_type: 'image/png' }, }
          end

        end
      end
    end
  end
end
