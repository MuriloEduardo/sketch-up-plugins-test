# frozen_string_literal: true

require 'json'
require 'tmpdir'
require 'test_helper'
require_devbridge 'error_journal', 'error_uploader'

class DevBridgeErrorUploaderTest < Minitest::Test

  Journal = MuriloEduardoDev::DevBridge::ErrorJournal
  Uploader = MuriloEduardoDev::DevBridge::ErrorUploader
  Config = Struct.new(:lab_url, :lab_token)

  def setup
    @dir = Dir.mktmpdir
    @journal = Journal.new(@dir)
    @calls = []
    @reply = [201, '{"ok":true}']
    @config = Config.new('https://site.test/', 'segredo')
    @uploader = Uploader.new(journal: @journal, config: @config, post: lambda { |url, headers, body, &done|
      @calls << [url, headers, JSON.parse(body)]
      @pending = done
      done.call(*@reply) unless @reply.nil?
    })
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def test_sends_pending_errors_and_moves_the_cursor
    2.times { |n| @journal.record(source: 'console', kind: 'E', message: "m#{n}") }

    assert(@uploader.tick)
    url, headers, body = @calls.first
    assert_equal('https://site.test/api/laboratorio/erros', url)
    assert_equal('Bearer segredo', headers['Authorization'])
    assert_equal(%w[m0 m1], body['errors'].map { |error| error['message'] })
    assert_empty(@journal.pending.items)
    assert_equal(2, @uploader.last[:sent])
  end

  def test_failed_delivery_keeps_errors_for_the_next_tick
    @journal.record(source: 'console', kind: 'E', message: 'm')
    @reply = [401, '{"error":"Token inválido."}']

    @uploader.tick
    assert_equal(1, @journal.pending.items.size)
    assert_equal(401, @uploader.last[:status])
    assert_includes(@uploader.last[:body], 'Token')

    @reply = [200, '{}']
    @uploader.tick
    assert_empty(@journal.pending.items)
  end

  def test_one_batch_at_a_time_while_the_answer_is_on_its_way
    @journal.record(source: 'console', kind: 'E', message: 'm')
    @reply = nil

    assert(@uploader.tick)
    refute(@uploader.tick, 'a resposta ainda não chegou')
    @pending.call(200, '')
    assert_empty(@journal.pending.items)
  end

  def test_nothing_happens_without_destination_or_errors
    refute(@uploader.tick, 'diário vazio')

    @journal.record(source: 'console', kind: 'E', message: 'm')
    @config.lab_token = nil
    refute(@uploader.tick)
    assert_empty(@calls)
  end

  def test_transport_error_is_reported_not_raised
    @journal.record(source: 'console', kind: 'E', message: 'm')
    uploader = Uploader.new(journal: @journal, config: @config, post: ->(*) { raise IOError, 'offline' })

    uploader.tick
    assert_equal('IOError: offline', uploader.last[:error])
    assert_equal(1, @journal.pending.items.size)
  end

end
