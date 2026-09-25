# frozen_string_literal: true

require 'test_helper'
require_devbridge 'console_parser'

class DevBridgeConsoleParserTest < Minitest::Test

  Parser = MuriloEduardoDev::DevBridge::ConsoleParser

  def setup
    @errors = []
    @parser = Parser.new { |error| @errors << error }
  end

  def test_sketchup_error_with_backtrace
    @parser.feed("Error: #<NoMethodError: undefined method `x' for nil:NilClass>\n")
    @parser.feed("C:/Users/L/AppData/Roaming/SketchUp/SketchUp 2026/SketchUp/Plugins/foo/a.rb:12:in `block in b'\n")
    @parser.feed("C:/Users/L/AppData/Roaming/SketchUp/SketchUp 2026/SketchUp/Plugins/foo/a.rb:5:in `call'\n")
    @parser.feed("next thing\n")

    assert_equal(1, @errors.size)
    error = @errors.first
    assert_equal('NoMethodError', error[:kind])
    assert_equal("undefined method `x' for nil:NilClass", error[:message])
    assert_equal(2, error[:backtrace].size)
    assert_includes(error[:tail], 'next thing')
  end

  def test_error_is_emitted_on_flush_and_chunks_can_split_lines
    @parser.feed('Error: #<RuntimeError: sp')
    @parser.feed("lit>\nC:/a.rb:1:in `m'")
    assert_empty(@errors)

    @parser.flush
    assert_equal([['RuntimeError', 'split', ["C:/a.rb:1:in `m'"]]], @errors.map { |e|
      e.values_at(:kind, :message, :backtrace)
    })
  end

  def test_ruby_uncaught_format_with_from_lines
    @parser.feed("C:/p/a.rb:3:in `m': undefined local variable or method `y' (NameError)\n\tfrom C:/p/b.rb:9:in `n'\n")
    @parser.flush

    assert_equal('NameError', @errors[0][:kind])
    assert_equal("undefined local variable or method `y'", @errors[0][:message])
    assert_equal(["C:/p/a.rb:3:in `m'", "C:/p/b.rb:9:in `n'"], @errors[0][:backtrace])
  end

  def test_plain_and_vray_lines
    @parser.feed("Error: could not load texture\n[V-Ray] Render failed: out of memory\nall good\n")

    assert_equal([['Error', 'could not load texture'], ['V-Ray', 'Render failed: out of memory']],
                 @errors.map { |e| e.values_at(:kind, :message) })
  end

  def test_ordinary_output_is_not_an_error
    @parser.feed("0 errors found\nRender finished\n#<Sketchup::Face:0x1>\nputs 1\n")
    @parser.flush

    assert_empty(@errors)
  end

  def test_two_errors_in_a_row
    @parser.feed("Error: #<TypeError: a>\nError: #<ArgumentError: b>\n")
    @parser.flush

    assert_equal(%w[TypeError ArgumentError], @errors.map { |e| e[:kind] })
  end

  def test_tail_is_bounded
    100.times { |n| @parser.feed("line #{n}\n") }

    assert_equal(Parser::TAIL_LINES, @parser.tail.size)
    assert_equal('line 99', @parser.tail.last)
  end

end
