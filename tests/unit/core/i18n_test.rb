# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/i18n'

class I18nTest < Minitest::Test

  I18n = MuriloEduardo::VRayToolkit::I18n

  STRINGS = {
    'en' => { hello: 'Hello %{name}', only_en: 'English only' },
    'pt-BR' => { hello: 'Olá %{name}' },
  }.freeze

  def teardown
    I18n.locale = nil
  end

  def test_exact_locale
    I18n.locale = 'pt-BR'

    assert_equal('Olá Ana', I18n.t(STRINGS, :hello, name: 'Ana'))
  end

  def test_same_language_other_region
    I18n.locale = 'pt-PT'

    assert_equal('Olá Ana', I18n.t(STRINGS, :hello, name: 'Ana'))
  end

  def test_falls_back_to_english_for_missing_key_or_locale
    I18n.locale = 'pt-BR'

    assert_equal('English only', I18n.t(STRINGS, :only_en))
    I18n.locale = 'fr'

    assert_equal('Hello Ana', I18n.t(STRINGS, :hello, name: 'Ana'))
  end

  def test_unknown_key_returns_key
    assert_equal('nope', I18n.t(STRINGS, :nope))
  end

  def test_missing_placeholder_value_is_kept
    assert_equal('Hello %{name}', I18n.t(STRINGS, :hello))
  end

  def test_default_locale_when_unset_or_empty
    I18n.locale = ''

    assert_equal('en', I18n.locale)
  end

end
