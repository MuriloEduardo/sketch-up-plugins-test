# frozen_string_literal: true

require 'json'
require 'tmpdir'
require 'test_helper'
require_devbridge 'error_journal'

class DevBridgeErrorJournalTest < Minitest::Test

  Journal = MuriloEduardoDev::DevBridge::ErrorJournal

  def setup
    @dir = Dir.mktmpdir
    @ids = (1..).lazy.map { |n| "id-#{n}" }.each_entry
    ids = @ids
    @journal = Journal.new(File.join(@dir, 'errors'), clock: -> { Time.utc(2026, 9, 25, 12) }, id: -> { ids.next })
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def test_uuid_is_random_version_four
    assert_match(/\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\z/, Journal.uuid)
    refute_equal(Journal.uuid, Journal.uuid)
  end

  def test_records_one_json_line_per_error
    @journal.record(source: 'console', kind: 'NoMethodError', message: 'boom', backtrace: ['a.rb:1'],
                    machine: 'DESKTOP', context: { port: 7860 })
    @journal.record(source: 'bridge', kind: '', message: '  ')

    lines = File.readlines(@journal.path).map { |line| JSON.parse(line) }
    assert_equal(%w[id-1 id-2], lines.map { |line| line['id'] })
    assert_equal('2026-09-25T12:00:00.000Z', lines[0]['at'])
    assert_equal({ 'port' => 7860 }, lines[0]['context'])
    assert_equal('Error', lines[1]['kind'])
    assert_equal('(sem mensagem)', lines[1]['message'])
  end

  def test_pending_advances_only_when_marked_sent
    3.times { |n| @journal.record(source: 'console', kind: 'E', message: "m#{n}") }

    first = @journal.pending(2)
    assert_equal(%w[m0 m1], first.items.map { |entry| entry['message'] })
    assert_equal(%w[m0 m1], @journal.pending(2).items.map { |entry| entry['message'] }, 'nada foi entregue ainda')

    @journal.mark_sent(first.offset)
    assert_equal(%w[m2], @journal.pending(2).items.map { |entry| entry['message'] })

    @journal.mark_sent(@journal.pending.offset)
    assert_empty(@journal.pending.items)
    assert_equal(3, File.readlines(@journal.path).size, 'entregar não apaga nada do diário')
  end

  def test_pending_skips_a_line_still_being_written
    @journal.record(source: 'console', kind: 'E', message: 'whole')
    File.open(@journal.path, 'a') { |file| file.write('{"id":"half"') }

    batch = @journal.pending
    assert_equal(%w[whole], batch.items.map { |entry| entry['message'] })
    assert_equal(File.size(@journal.path) - '{"id":"half"'.bytesize, batch.offset)
  end

  def test_windows_messages_keep_their_accents
    ansi = 'Normalmente é permitida apenas uma utilização'.encode(Encoding::WINDOWS_1252)
    @journal.record(source: 'bridge', kind: 'E', message: ansi)
    @journal.record(source: 'bridge', kind: 'E', message: ansi.b)

    assert_equal(['Normalmente é permitida apenas uma utilização'] * 2, @journal.recent.map { |entry|
      entry['message']
    })
  end

end
