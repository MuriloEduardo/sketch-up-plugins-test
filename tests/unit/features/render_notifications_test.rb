# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'
require_source 'me_vray_toolkit/features/render_notifications/messages'

class RenderNotificationsTest < Minitest::Test

  Notifications = MuriloEduardo::VRayToolkit::Features::RenderNotifications
  I18n = MuriloEduardo::VRayToolkit::I18n

  def setup
    I18n.locale = 'pt-BR'
  end

  def teardown
    I18n.locale = nil
  end

  def job(**changes)
    { kind: 'render', details: { scene: 'Interior', width: 640, height: 360 }, message: 'Done',
      elapsed_seconds: 34.6, started_at: '2026-09-25T09:30:00-03:00', progress: nil, }.merge(changes)
  end

  def test_start_and_end_are_announced
    assert_equal('Render iniciado: Interior (640×360) às 09:30', Notifications::Messages.notice('job.running', job))
    assert_equal('Render concluído: Interior em 35 s', Notifications::Messages.notice('job.done', job))
  end

  def test_time_limit_failure_and_cancel
    limited = job(message: 'Done (time limit reached)')

    assert_match(/limite de tempo/, Notifications::Messages.notice('job.done', limited))
    assert_equal('Render falhou: Interior. boom', Notifications::Messages.notice('job.failed', job(error: 'boom')))
    assert_equal('Render cancelado: Interior', Notifications::Messages.notice('job.cancelled', job))
  end

  def test_progress_updates_are_not_notifications
    assert_nil(Notifications::Messages.notice('job.running', job(progress: 0.5)))
    assert_equal('V-Ray renderizando Interior: Rendering', Notifications::Messages.status(job(message: 'Rendering')))
  end

  def test_batches_and_other_jobs
    batch = job(kind: 'render_batch', details: { scenes: %w[A B C] }, message: '3 rendered, 0 failed')

    assert_equal('Render em lote iniciado: 3 cenas às 09:30', Notifications::Messages.notice('job.running', batch))
    assert_equal('Render em lote concluído: 3 rendered, 0 failed em 35 s',
                 Notifications::Messages.notice('job.done', batch))
    assert_nil(Notifications::Messages.notice('job.done', job(kind: 'export')))
  end

  def test_every_locale_translates_every_key
    keys = Notifications::STRINGS.fetch('en').keys
    Notifications::STRINGS.each { |locale, strings| assert_equal(keys.sort, strings.keys.sort, locale) }
  end

end
