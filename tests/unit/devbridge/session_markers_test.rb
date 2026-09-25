# frozen_string_literal: true

require 'tmpdir'
require 'test_helper'
require_devbridge 'session_markers'

class DevBridgeSessionMarkersTest < Minitest::Test

  Markers = MuriloEduardoDev::DevBridge::SessionMarkers

  def setup
    @dir = Dir.mktmpdir
    @alive = [100]
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def markers(pid)
    Markers.new(@dir, pid: pid, alive: ->(other) { @alive.include?(other) }, clock: lambda {
      Time.utc(2026, 9, 25, pid % 24)
    })
  end

  def test_normal_close_leaves_nothing_behind
    first = markers(1)
    first.open
    first.close

    assert_empty(markers(2).open)
  end

  def test_session_of_a_dead_process_is_reported_once
    markers(1).open(sketchup_version: '26.1')

    dead = markers(2).open
    assert_equal([1], dead.map { |marker| marker['pid'] })
    assert_equal('26.1', dead.first['sketchup_version'])
    assert_empty(markers(3).open.select { |marker| marker['pid'] == 1 }, 'o marcador do morto foi consumido')
  end

  def test_other_running_instance_is_not_a_crash
    markers(100).open

    assert_empty(markers(2).open)
  end

  def test_unreadable_marker_is_discarded
    File.write(File.join(@dir, 'session-9.json'), '{broken')

    assert_empty(markers(2).open)
    refute(File.exist?(File.join(@dir, 'session-9.json')))
  end

end
