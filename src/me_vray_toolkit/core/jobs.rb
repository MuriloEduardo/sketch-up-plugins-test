# frozen_string_literal: true

require 'time'

module MuriloEduardo
  module VRayToolkit
    # Long-running work (renders, batch exports) tracked by id so a caller
    # can start it and come back for the result without blocking SketchUp
    # (pillar P4). Each state change publishes "job.<state>" on {Events},
    # other updates "job.progress".
    #
    #   job = Jobs.create(kind: 'render', details: { scene: 'P.Planta' })
    #   Jobs.update(job.id, state: :running, progress: 0.4, message: 'Rendering')
    #   Jobs.update(job.id, state: :done, result: { path: 'C:/…/render.png' })
    #
    # Pure Ruby (needs {Events} loaded): unit tested in the Docker toolchain.
    module Jobs

      STATES = %i[queued running done failed cancelled].freeze
      FINISHED = %i[done failed cancelled].freeze
      KEEP = 50

      # @!attribute progress [Float, nil] 0.0..1.0 when known
      Job = Struct.new(:id, :kind, :state, :progress, :message, :details, :result, :error, :created_at,
                       :updated_at, keyword_init: true) do
        def finished?
          FINISHED.include?(state)
        end

        # @return [Float] seconds since creation (until the last update once finished)
        def elapsed
          ((finished? ? updated_at : Time.now) - created_at).round(1)
        end

        # @return [Hash] plain data for tools and events; times in ISO 8601
        def to_h
          { id: id, kind: kind, state: state, progress: progress, message: message, details: details,
            result: result, error: error, elapsed_seconds: elapsed, started_at: created_at.iso8601,
            finished_at: finished? ? updated_at.iso8601 : nil, }
        end
      end

      # ||= keeps running jobs when the file is reloaded during development.
      @jobs ||= {}
      @sequence ||= 0

      class << self

        # @param kind [String] e.g. "render"
        # @param details [Hash] what the job is about
        # @return [Job] queued
        def create(kind:, details: {})
          @sequence += 1
          now = Time.now
          job = Job.new(id: "#{kind}-#{@sequence}", kind: kind, state: :queued, details: details, created_at: now,
                        updated_at: now)
          @jobs[job.id] = job
          prune
          Events.publish('job.queued', job.to_h)
          job
        end

        # @param id [String]
        # @param changes [Hash] any of state:, progress:, message:, result:, error:
        # @return [Job]
        # @raise [KeyError] unknown job
        # @raise [ArgumentError] invalid state or change to a finished job
        def update(id, **changes)
          job = fetch(id)
          raise ArgumentError, "job #{id} already #{job.state}" if job.finished?

          state = changes.fetch(:state, job.state)
          raise ArgumentError, "invalid job state: #{state.inspect}" unless STATES.include?(state)

          changed = state != job.state
          changes.each { |key, value| job[key] = value }
          job.updated_at = Time.now
          # "job.<state>" once per transition (e.g. job.running = started);
          # later updates in the same state are "job.progress".
          Events.publish(changed ? "job.#{state}" : 'job.progress', job.to_h)
          job
        end

        # @param id [String]
        # @return [Job]
        # @raise [KeyError]
        def fetch(id)
          @jobs.fetch(id.to_s) { raise KeyError, "no job #{id}" }
        end

        # @param kind [String, nil]
        # @return [Array<Job>] newest first
        def all(kind: nil)
          jobs = @jobs.values.reverse
          kind ? jobs.select { |job| job.kind == kind } : jobs
        end

        # Removes every job. For tests.
        def clear
          @jobs.clear
          @sequence = 0
        end

        private

        # Forgets the oldest finished jobs beyond KEEP.
        def prune
          finished = @jobs.values.select(&:finished?)
          finished.first([@jobs.size - KEEP, 0].max).each { |job| @jobs.delete(job.id) }
        end

      end

    end
  end
end
