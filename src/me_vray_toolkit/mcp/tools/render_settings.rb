# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/core/jobs')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # V-Ray status and the render settings saved in the model.
        module RenderSettings

          extend Support

          QUALITY = VRayBridge::QualityPreset

          Actions.register(
              name: 'vray_status', group: :vray, read_only: true,
              description: 'Whether V-Ray is available, its version, the current render settings and the ' \
                           'renders of this session (latest first).'
            ) do
            status = VRayBridge.status.slice(:vray_version, :vray_api_version, :vray_api_available)
            status[:render_settings] = render_settings if VRayBridge.available?
            status.merge(renders: Jobs.all(kind: 'render').first(5).map(&:to_h))
          end

          Actions.register(
              name: 'get_render_settings', group: :vray, read_only: true,
              description: 'V-Ray render settings: output size in pixels, quality preset ' \
                           "(#{QUALITY.labels.join(', ')}), time limit, noise limit and whether the GPU engine is used."
            ) do
            require_vray
            render_settings
          end

          Actions.register(
              name: 'set_render_settings', group: :vray, idempotent: true,
              description: 'Changes V-Ray render settings (only the given ones); they apply to the next renders ' \
                           'at once and ' \
                           'are kept in the .skp when the user saves the model. One undo step.',
              schema: {
                width: { type: :integer, range: 16..16_384, description: 'Output width in pixels' },
                height: { type: :integer, range: 16..16_384, description: 'Output height in pixels' },
                quality: { type: :enum, values: QUALITY.labels, description: 'Quality preset' },
                time_limit_minutes: { type: :number, range: 0..1440,
                                      description: 'Stop after this many minutes; 0 turns the limit off', },
                noise_limit: { type: :number, range: 0.001..1.0,
                               description: 'Progressive noise threshold; lower is cleaner and slower', },
              }
            ) do |params|
            require_vray
            values = params.slice(:width, :height).compact
            values[:quality_preset] = QUALITY.value_for(params[:quality]) if params[:quality]
            unless params[:time_limit_minutes].nil?
              values[:time_limit_on] = params[:time_limit_minutes].positive?
              values[:time_limit_minutes] = params[:time_limit_minutes] if params[:time_limit_minutes].positive?
            end
            values[:noise_limit] = params[:noise_limit] if params[:noise_limit]
            raise ArgumentError, 'give at least one setting to change' if values.empty?

            change('Set V-Ray Render Settings') { VRayBridge.update_render_settings(values) }
            render_settings
          end

        end
      end
    end
  end
end
