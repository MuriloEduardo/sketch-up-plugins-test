# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/core/html'

class HtmlTest < Minitest::Test

  Html = MuriloEduardo::VRayToolkit::Html

  def test_escape
    assert_equal('&lt;b&gt; &amp; &quot;x&quot; &#39;y&#39;', Html.escape(%(<b> & "x" 'y')))
    assert_equal('42', Html.escape(42))
  end

  def test_table_escapes_headers_but_not_cells
    html = Html.table(['<Name>'], [['<i>ok</i>']])

    assert_includes(html, '<th>&lt;Name&gt;</th>')
    assert_includes(html, '<td><i>ok</i></td>')
  end

  def test_document_escapes_title_and_sets_lang
    html = Html.document(title: 'A & B', body: '<p>x</p>', lang: 'pt-BR')

    assert_includes(html, '<html lang="pt-BR">')
    assert_includes(html, '<title>A &amp; B</title>')
    assert_includes(html, '<p>x</p>')
    assert_includes(html, 'prefers-color-scheme: dark')
  end

end
