# frozen_string_literal: true

require 'test_helper'
require_devbridge 'port_owner'

class DevBridgePortOwnerTest < Minitest::Test

  PortOwner = MuriloEduardoDev::DevBridge::PortOwner

  NETSTAT = <<~TEXT

    Active Connections

      Proto  Local Address          Foreign Address        State           PID
      TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       1012
      TCP    127.0.0.1:17860        127.0.0.1:0            LISTENING       77
      TCP    127.0.0.1:7860         0.0.0.0:0              LISTENING       4321
      TCP    127.0.0.1:7860         127.0.0.1:50000        ESTABLISHED     4321
  TEXT

  def test_finds_the_listener_of_the_exact_port
    assert_equal(4321, PortOwner.listening_pid(NETSTAT, 7860))
    assert_nil(PortOwner.listening_pid(NETSTAT, 7861))
  end

  def test_image_name_from_tasklist_csv
    assert_equal('SketchUp.exe', PortOwner.image_name(%("SketchUp.exe","4321","Console","1","812.345 K"\n)))
    assert_nil(PortOwner.image_name("INFO: No tasks are running which match the specified criteria.\n"))
  end

  def test_explains_another_sketchup_holding_the_port
    text = PortOwner.explain(Errno::EADDRINUSE.new('bind'), { pid: 4321, name: 'SketchUp.exe', same_process: false },
                             '127.0.0.1:7860')

    assert_includes(text, '127.0.0.1:7860')
    assert_includes(text, 'SketchUp.exe (PID 4321)')
    assert_includes(text, 'error audit')
  end

  def test_explains_when_this_sketchup_already_runs_the_bridge
    text = PortOwner.explain(Errno::EADDRINUSE.new('bind'), { pid: 1, name: 'SketchUp.exe', same_process: true }, 'a:1')

    assert_includes(text, 'probably running')
  end

end
