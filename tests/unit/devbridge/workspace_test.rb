# frozen_string_literal: true

require 'tmpdir'
require 'test_helper'
require_devbridge 'security', 'workspace'

class DevBridgeWorkspaceTest < Minitest::Test

  Workspace = MuriloEduardoDev::DevBridge::Workspace

  def setup
    @dir = Dir.mktmpdir
    @workspace = Workspace.new(@dir)
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def test_sync_writes_files
    result = @workspace.sync({ 'src/a.rb' => 'A', 'tests/sketchup/t.rb' => 'T' })

    assert_equal(2, result[:written])
    assert_equal('A', File.read(File.join(@dir, 'src/a.rb')))
  end

  def test_sync_skips_unchanged_files
    @workspace.sync({ 'src/a.rb' => 'A' })

    result = @workspace.sync({ 'src/a.rb' => 'A' })

    assert_equal(0, result[:written])
    assert_equal(1, result[:unchanged])
  end

  def test_sync_prunes_missing_files_and_empty_folders
    @workspace.sync({ 'src/a.rb' => 'A', 'src/old/b.rb' => 'B' })

    result = @workspace.sync({ 'src/a.rb' => 'A' })

    assert_equal(1, result[:deleted])
    refute(File.exist?(File.join(@dir, 'src/old')))
  end

  def test_sync_rejects_unsafe_paths_without_writing
    assert_raises(ArgumentError) { @workspace.sync({ 'src/ok.rb' => 'x', '../evil.rb' => 'x' }) }
    refute(File.exist?(File.join(@dir, 'src/ok.rb')))
  end

  def test_reload_requires_registration_and_loads_implementation
    @workspace.sync({
                      'src/ws_probe.rb' => "WS_PROBE_REGISTERED = true\n",
                      'src/ws_probe/impl.rb' => "$ws_probe_loads = ($ws_probe_loads || 0) + 1\n",
                    })

    first = @workspace.reload
    @workspace.reload

    assert_equal(['ws_probe.rb'], first[:registered])
    assert_equal(2, $ws_probe_loads) # rubocop:disable Style/GlobalVars
  ensure
    $LOAD_PATH.delete(@workspace.source_dir)
  end

end
