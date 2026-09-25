# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/render_batch')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Rendering many scenes in one go.
        module RenderBatch

          extend Support

          Actions.register(
              name: 'render_all_scenes', group: :vray,
              description: 'Renders the scenes one after the other with V-Ray (all, or those whose names start ' \
                           'with a prefix) and returns a batch id at once. Poll get_render_status with it: when ' \
                           'done it lists every render with its file; get_render_status on a render id shows its ' \
                           'picture. Scenes excluded from animation are skipped unless include_all is true.',
              schema: {
                prefix: { type: :string, default: '', description: 'Comma separated name prefixes; empty = all' },
                include_all: { type: :boolean, default: false, description: 'Also scenes excluded from animation' },
                width: { type: :integer, range: 16..16_384, description: 'Pixels; default from the render settings' },
                height: { type: :integer, range: 16..16_384, description: 'Pixels; default from the render settings' },
                max_minutes: { type: :number, range: 0.05..600, default: 2.0, description: 'Time limit per scene' },
              }
            ) do |params|
            require_vray
            prefixes = params[:prefix].split(',').map(&:strip).reject(&:empty?).map(&:downcase)
            pages = model.pages.select do |page|
              (params[:include_all] || page.include_in_animation?) &&
                (prefixes.empty? || prefixes.any? { |prefix| page.name.downcase.start_with?(prefix) })
            end
            raise ArgumentError, 'no scene matches' if pages.empty?

            saved = VRayBridge.render_settings
            size = { width: params[:width] || saved[:width], height: params[:height] || saved[:height] }
            VRayBridge::RenderBatch.start(model: model, scenes: pages.map(&:name), max_minutes: params[:max_minutes],
                                          **size).to_h
          end

        end
      end
    end
  end
end
