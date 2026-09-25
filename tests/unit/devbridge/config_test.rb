# frozen_string_literal: true

require 'json'
require 'tmpdir'
require 'test_helper'
require_devbridge 'config'

class DevBridgeConfigTest < Minitest::Test

  Config = MuriloEduardoDev::DevBridge::Config

  def setup
    @dir = Dir.mktmpdir
    @path = File.join(@dir, 'nested', 'config.json')
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def test_creates_file_with_random_token
    config = Config.new(@path)

    assert(File.exist?(@path))
    assert_equal(48, config.token.size)
  end

  def test_keeps_token_between_loads
    token = Config.new(@path).token

    assert_equal(token, Config.new(@path).token)
  end

  def test_always_binds_loopback_even_if_file_says_otherwise
    File.write(@path, JSON.generate('bind' => '0.0.0.0', 'token' => 'x' * 48)) if FileUtils.mkdir_p(File.dirname(@path))

    assert_equal('127.0.0.1', Config.new(@path).bind)
  end

  def test_autostart_is_off_by_default
    refute(Config.new(@path).autostart?)
  end

  def test_autostart_setting_is_saved
    Config.new(@path).autostart = true

    assert(Config.new(@path).autostart?)
    Config.new(@path).autostart = false

    refute(Config.new(@path).autostart?)
  end

  def test_regenerate_token_changes_and_persists
    config = Config.new(@path)
    old = config.token

    new = config.regenerate_token

    refute_equal(old, new)
    assert_equal(new, Config.new(@path).token)
  end

  def test_error_audit_destination_is_saved_and_optional
    config = Config.new(@path)
    assert_nil(config.lab_url)

    config.set_lab(url: ' https://lilianrosa.com.br/ ', token: 'abc')
    assert_equal(['https://lilianrosa.com.br', 'abc'], Config.new(@path).then { |c| [c.lab_url, c.lab_token] })

    config.set_lab(url: '', token: '')
    assert_nil(Config.new(@path).lab_token)
  end

end
