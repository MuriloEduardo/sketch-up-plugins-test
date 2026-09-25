# frozen_string_literal: true

require 'test_helper'
require_devbridge 'windows_processes', 'ghost_watch'

class DevBridgeWindowsProcessesTest < Minitest::Test

  WindowsProcesses = MuriloEduardoDev::DevBridge::WindowsProcesses
  GhostWatch = MuriloEduardoDev::DevBridge::GhostWatch

  # What the PowerShell list printed on the desktop on 2026-09-25 (six SketchUps, one window).
  OUTPUT = <<~TEXT
    3480 0 2026-09-25T10:29:59
    11540 1312874 2026-09-25T14:00:49
    14596 0 2026-09-25T11:01:46
    garbage line
    14728 0 2026-09-25T10:15:03
  TEXT

  def test_parses_pid_window_and_start
    processes = WindowsProcesses.parse(OUTPUT)

    assert_equal([3480, 11_540, 14_596, 14_728], processes.map { |process| process[:pid] })
    assert_equal({ pid: 11_540, window: true, started_at: '2026-09-25T14:00:49' }, processes[1])
    refute(processes[0][:window])
  end

  def test_ghosts_exclude_this_process_and_any_with_a_window
    ghosts = WindowsProcesses.ghosts(WindowsProcesses.parse(OUTPUT), 14_596)

    assert_equal([3480, 14_728], ghosts.map { |ghost| ghost[:pid] })
  end

  def test_only_a_ghost_holding_the_port_may_be_ended
    processes = WindowsProcesses.parse(OUTPUT)

    assert_equal(3480, GhostWatch.reclaimable(3480, processes, 11_540)[:pid])
    assert_nil(GhostWatch.reclaimable(11_540, processes, 3480), 'a SketchUp with a window is never ended')
    assert_nil(GhostWatch.reclaimable(3480, processes, 3480), 'never itself')
    assert_nil(GhostWatch.reclaimable(999, processes, 11_540), 'not a SketchUp')
    assert_nil(GhostWatch.reclaimable(nil, processes, 11_540))
  end

  def test_retry_listen_waits_for_the_port
    attempts = 0
    GhostWatch.stub(:sleep, nil) do
      assert(GhostWatch.listening_after_retries? do
        attempts += 1
        raise Errno::EADDRINUSE if attempts < 3
      end)
      refute(GhostWatch.listening_after_retries? { raise Errno::EADDRINUSE })
    end
    assert_equal(3, attempts)
  end

  def test_off_windows_nothing_runs
    assert_equal('', WindowsProcesses.capture('netstat -ano')) unless Gem.win_platform?
  end

end
