# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/jobs')
Sketchup.require('me_vray_toolkit/vray/render_job')

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Renders several scenes one after the other as one "render_batch" job.
      # Each scene is a normal render job; the next starts when {Events}
      # announces the previous one finished (no polling).
      module RenderBatch

        FINISHED_TOPICS = %w[job.done job.failed job.cancelled].freeze

        # ||= keeps running batches when the file is reloaded during development.
        @batches ||= {}

        class << self

          # @param model [Sketchup::Model]
          # @param scenes [Array<String>] scene names, in order
          # @param width [Integer]
          # @param height [Integer]
          # @param max_minutes [Float, nil] per scene
          # @return [Jobs::Job] the batch job
          # @raise [ArgumentError] without scenes
          def start(model:, scenes:, width:, height:, max_minutes: nil)
            raise ArgumentError, 'no scenes to render' if scenes.empty?

            subscribe
            batch = Jobs.create(kind: 'render_batch', details: { model: model.title, scenes: scenes, width: width,
                                                                 height: height, max_minutes: max_minutes, })
            @batches[batch.id] = { model: model, queue: scenes.dup, total: scenes.size, renders: [], current: nil,
                                   options: { width: width, height: height, max_minutes: max_minutes }, }
            Jobs.update(batch.id, state: :running, progress: 0.0, message: "0/#{scenes.size}")
            next_scene(batch.id)
            Jobs.fetch(batch.id)
          end

          # Stops the current render and skips the rest.
          #
          # @param batch_id [String]
          # @raise [ArgumentError] if it is not running
          def cancel(batch_id)
            entry = @batches[batch_id] or raise ArgumentError, "render batch #{batch_id} is not running"
            entry[:queue].clear
            entry[:cancelled] = true
            RenderJob.cancel(entry[:current]) if entry[:current]
          end

          private

          # Once per session: every batch listens through the same subscriber.
          def subscribe
            @subscribe ||= Events.subscribe('job.') { |event| job_finished(event) }
          end

          def job_finished(event)
            return unless FINISHED_TOPICS.include?(event.topic)

            batch_id, entry = @batches.find { |_id, candidate| candidate[:current] == event.payload[:id] }
            return unless entry

            entry[:renders] << event.payload.slice(:id, :state, :result,
                                                   :error).merge(scene: event.payload[:details][:scene])
            entry[:current] = nil
            done = entry[:renders].size
            Jobs.update(batch_id, progress: (done.to_f / entry[:total]).round(2), message: "#{done}/#{entry[:total]}")
            # Leave the event handler before starting the next render.
            UI.start_timer(0, false) { next_scene(batch_id) }
          end

          def next_scene(batch_id)
            entry = @batches[batch_id] or return
            scene = entry[:queue].shift
            return finish(batch_id, entry) if scene.nil?

            model = entry[:model]
            page = model.pages[scene]
            if page.nil?
              entry[:renders] << { scene: scene, state: :failed, error: "no scene named #{scene}" }
              return next_scene(batch_id)
            end
            RenderJob.show_scene(model, page)
            entry[:current] = RenderJob.start(model: model, scene: scene, **entry[:options]).id
          rescue StandardError => error
            entry[:renders] << { scene: scene, state: :failed, error: "#{error.class}: #{error.message}" }
            retry_next = !entry[:cancelled]
            retry_next ? next_scene(batch_id) : finish(batch_id, entry)
          end

          def finish(batch_id, entry)
            @batches.delete(batch_id)
            state = entry[:cancelled] ? :cancelled : :done
            failed = entry[:renders].count { |render| render[:state] != :done }
            message = "#{entry[:renders].size - failed} rendered, #{failed} failed"
            Jobs.update(batch_id, state: state, progress: 1.0, message: message, result: { renders: entry[:renders] })
          end

        end

      end
    end
  end
end
