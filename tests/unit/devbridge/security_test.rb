# frozen_string_literal: true

require 'test_helper'
require_devbridge 'security'

class DevBridgeSecurityTest < Minitest::Test

  Security = MuriloEduardoDev::DevBridge::Security
  ROOTS = %w[src tests].freeze

  def test_token_matches_identical_token
    assert(Security.token_matches?('abc123', 'abc123'))
  end

  def test_token_rejects_different_token
    refute(Security.token_matches?('abc123', 'abc124'))
  end

  def test_token_rejects_missing_token
    refute(Security.token_matches?('abc123', nil))
  end

  def test_token_rejects_when_expected_is_empty
    refute(Security.token_matches?('', ''))
  end

  def test_loopback_accepts_local_addresses
    assert(Security.loopback?('127.0.0.1'))
    assert(Security.loopback?('::1'))
  end

  def test_loopback_rejects_lan_address
    refute(Security.loopback?('192.168.0.10'))
  end

  def test_safe_path_accepts_file_under_root
    assert(Security.safe_relative_path?('src/me_ext/main.rb', ROOTS))
  end

  def test_safe_path_rejects_traversal
    refute(Security.safe_relative_path?('src/../../evil.rb', ROOTS))
  end

  def test_safe_path_rejects_absolute_and_drive_paths
    refute(Security.safe_relative_path?('/etc/passwd', ROOTS))
    refute(Security.safe_relative_path?('C:/Windows/x.rb', ROOTS))
  end

  def test_safe_path_rejects_backslashes
    refute(Security.safe_relative_path?('src\\x.rb', ROOTS))
  end

  def test_safe_path_rejects_unknown_root
    refute(Security.safe_relative_path?('tools/x.rb', ROOTS))
  end

  def test_safe_path_rejects_root_itself
    refute(Security.safe_relative_path?('src', ROOTS))
  end

end
