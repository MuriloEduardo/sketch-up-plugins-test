# frozen_string_literal: true

require 'base64'

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/core/jobs')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/render_job')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # V-Ray production renders as jobs: start, follow, cancel.
        module Render

          extend Support

          # Pictures larger than this are only referenced by path.
          MAX_IMAGE_BYTES = 4 * 1024 * 1024

          def self.job_with_image(job, include_image)
            data = job.to_h
            path = job.result && job.result[:path]
            return data unless include_image && path && File.exist?(path) && File.size(path) <= MAX_IMAGE_BYTES

            data.merge(image: { data: Base64.strict_encode64(File.binread(path)), mime_type: 'image/png' })
          end

          def self.render_job(id)
            job = Jobs.fetch(id)
            raise ArgumentError, "#{id} is not a render" unless job.kind == 'render'

            job
          rescue KeyError
            raise ArgumentError, "no render #{id}"
          end

          JOB_ID = { type: :string, required: true, description: 'Render id from render_scene' }.freeze

          Actions.register(
              name: 'render_scene', group: :vray,
              description: 'Starts a V-Ray production render of a scene (or the current view) and returns a render ' \
                           'id at once; poll get_render_status for progress and the picture. The image is saved ' \
                           'in a "<model> renders" folder next to the model. The model\'s saved settings are not ' \
                           'changed; width/height/max_minutes apply to this render only.',
              schema: {
                scene: { type: :string, description: 'Scene to render; empty = current view' },
                width: { type: :integer, range: 16..16_384, description: 'Pixels; default from the render settings' },
                height: { type: :integer, range: 16..16_384, description: 'Pixels; default from the render settings' },
                max_minutes: { type: :number, range: 0.05..600, default: 2.0,
                               description: 'Progressive render time limit in minutes', },
              }
            ) do |params|
            require_vray
            scene = params[:scene].to_s.empty? ? nil : params[:scene]
            if scene
              page = model.pages[scene] or raise ArgumentError, "no scene named #{scene}"
              model.pages.selected_page = page
            end
            saved = VRayBridge.render_settings
            job = VRayBridge::RenderJob.start(model: model, scene: scene, width: params[:width] || saved[:width],
                                              height: params[:height] || saved[:height],
                                              max_minutes: params[:max_minutes])
            job.to_h
          end

          Actions.register(
              name: 'get_render_status', group: :vray, read_only: true,
              description: 'State, progress and elapsed time of a render; when done, the file path and the picture.',
              schema: { id: JOB_ID,
                        include_image: { type: :boolean, default: true, description: 'Return the picture when done' }, }
            ) { |params| job_with_image(render_job(params[:id]), params[:include_image]) }

          Actions.register(
              name: 'cancel_render', group: :vray,
              description: 'Stops a running render.', schema: { id: JOB_ID }
            ) do |params|
            VRayBridge::RenderJob.cancel(render_job(params[:id]).id)
            render_job(params[:id]).to_h
          end

        end
      end
    end
  end
end
