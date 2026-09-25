# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/events'
require_source 'me_vray_toolkit/core/jobs'

class JobsTest < Minitest::Test

  Jobs = MuriloEduardo::VRayToolkit::Jobs
  Events = MuriloEduardo::VRayToolkit::Events

  def setup
    Jobs.clear
    Events.clear
  end

  def test_lifecycle_publishes_events
    job = Jobs.create(kind: 'render', details: { scene: 'P.Planta' })
    Jobs.update(job.id, state: :running, progress: 0.5, message: 'Rendering')
    Jobs.update(job.id, state: :done, result: { path: 'C:/r.png' })

    assert_equal('render-1', job.id)
    assert_equal(%w[job.queued job.running job.done], Events.recent('job.').map(&:topic))
    assert(Jobs.fetch('render-1').finished?)
    assert_equal({ path: 'C:/r.png' }, Events.recent('job.done').last.payload[:result])
  end

  def test_finished_jobs_cannot_change
    job = Jobs.create(kind: 'render')
    Jobs.update(job.id, state: :cancelled)

    assert_raises(ArgumentError) { Jobs.update(job.id, state: :running) }
  end

  def test_invalid_state_and_unknown_job
    job = Jobs.create(kind: 'render')

    assert_raises(ArgumentError) { Jobs.update(job.id, state: :exploded) }
    assert_raises(KeyError) { Jobs.fetch('nope') }
  end

  def test_all_filters_by_kind_newest_first
    first = Jobs.create(kind: 'render')
    Jobs.create(kind: 'export')
    last = Jobs.create(kind: 'render')

    assert_equal([last.id, first.id], Jobs.all(kind: 'render').map(&:id))
  end

  def test_old_finished_jobs_are_forgotten
    (Jobs::KEEP + 5).times do
      job = Jobs.create(kind: 'render')
      Jobs.update(job.id, state: :done)
    end
    Jobs.create(kind: 'render')

    assert_operator(Jobs.all.size, :<=, Jobs::KEEP + 1)
  end

end
