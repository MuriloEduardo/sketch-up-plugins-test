# frozen_string_literal: true

require 'fileutils'

Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/jobs')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/render_output')

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Production renders as {Jobs}: {.start} returns at once and the job
      # follows V-Ray's own events (no polling, no sleeping), then saves the
      # image next to the model. One render at a time, like V-Ray itself.
      module RenderJob

        SUCCESS = %i[idleDone idleFrameDone].freeze
        FAILURE = %i[idleError fatalError].freeze
        STOPPED = %i[idleStopped].freeze
        # Step progress closer than this is not republished.
        PROGRESS_STEP = 0.1

        # Receives the renderer's events and forwards them to the job.
        class Listener

          def initialize(job_id)
            @job_id = job_id
          end

          def on_state_changed(_renderer, _old_state, new_state, _instant)
            RenderJob.state_changed(@job_id, new_state)
          end

          def on_progress(_renderer, message, element_number, element_count, _instant)
            RenderJob.progressed(@job_id, message, element_number, element_count)
          end

        end

        # ||= keeps a running render when the file is reloaded during development.
        @active ||= {}

        class << self

          # @param model [Sketchup::Model]
          # @param width [Integer]
          # @param height [Integer]
          # @param max_minutes [Float, nil]
          # @param scene [String, nil] shown in the file name and job details
          # @return [Jobs::Job]
          # @raise [ArgumentError] while another render runs
          def start(model:, width:, height:, max_minutes: nil, scene: nil)
            running = @active.keys.first
            raise ArgumentError, "a render is already running (#{running}); wait or cancel it" if running

            job = Jobs.create(kind: 'render', details: { model: model.title, scene: scene, width: width,
                                                         height: height, max_minutes: max_minutes, })
            listener = Listener.new(job.id)
            output = RenderOutput.path(model_path: model.path, scene: scene, time: Time.now,
                                       temp_dir: Sketchup.temp_dir)
            @active[job.id] = { listener: listener, output: output, renderer: nil }
            Jobs.update(job.id, state: :running, message: 'Exporting the scene to V-Ray')
            @active[job.id][:renderer] = VRayBridge.start_render(model: model, width: width, height: height,
                                                                 max_minutes: max_minutes, listener: listener)
            job
          rescue StandardError => error
            fail_job(job, error) if job
            raise
          end

          # @param job_id [String]
          # @raise [ArgumentError] if it is not running
          def cancel(job_id)
            entry = @active[job_id] or raise ArgumentError, "render #{job_id} is not running"
            VRayBridge.stop_render(entry[:renderer])
          end

          # @api private (called by Listener)
          def state_changed(job_id, state)
            return unless @active.key?(job_id)

            if SUCCESS.include?(state) || FAILURE.include?(state) || STOPPED.include?(state)
              # Leave V-Ray's callback before saving files.
              UI.start_timer(0, false) { finish(job_id, state) }
            else
              Jobs.update(job_id, message: state.to_s)
            end
          end

          # V-Ray reports progress per step (exporting, compiling lights,
          # rendering), not for the whole render, so it goes in the message;
          # the job's progress only reaches 1.0 when the image is saved.
          #
          # @api private (called by Listener)
          def progressed(job_id, message, done, total)
            entry = @active[job_id]
            return unless entry && total.to_i.positive?

            step = (done.to_f / total).clamp(0.0, 1.0)
            last = entry[:step]
            return if last && last[0] == message && (step - last[1]).abs < PROGRESS_STEP && step < 1.0

            entry[:step] = [message, step]
            Jobs.update(job_id, message: "#{message.to_s.strip} (#{(step * 100).round}%)")
          end

          private

          def finish(job_id, state)
            entry = @active.delete(job_id) or return
            VRayBridge.release_render(entry[:renderer], entry[:listener])
            if SUCCESS.include?(state)
              FileUtils.mkdir_p(File.dirname(entry[:output]))
              size = VRayBridge.save_render(entry[:renderer], entry[:output])
              Jobs.update(job_id, state: :done, progress: 1.0, message: 'Done',
                                  result: size.merge(path: entry[:output]))
            elsif STOPPED.include?(state)
              Jobs.update(job_id, state: :cancelled, message: 'Stopped')
            else
              Jobs.update(job_id, state: :failed, error: "V-Ray finished with #{state}")
            end
          rescue StandardError => error
            fail_job(Jobs.fetch(job_id), error)
          end

          def fail_job(job, error)
            @active.delete(job.id)
            Jobs.update(job.id, state: :failed, error: "#{error.class}: #{error.message}") unless job.finished?
          end

        end

      end
    end
  end
end
