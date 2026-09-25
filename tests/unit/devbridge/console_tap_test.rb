# frozen_string_literal: true

require 'test_helper'

# Stand-in for the real Diagnostics (which needs SketchUp): records what the
# tap hands over.
unless defined?(MuriloEduardoDev::DevBridge::Diagnostics)
  MuriloEduardoDev = Module.new unless defined?(MuriloEduardoDev)
  MuriloEduardoDev::DevBridge = Module.new unless defined?(MuriloEduardoDev::DevBridge)
  MuriloEduardoDev::DevBridge.const_set(:Diagnostics, Module.new do
    def self.console(text) = texts << text
    def self.texts = @texts ||= []
  end)
end

require_devbridge 'console_tap'

class DevBridgeConsoleTapTest < Minitest::Test

  Tap = MuriloEduardoDev::DevBridge::ConsoleTap
  Diagnostics = MuriloEduardoDev::DevBridge::Diagnostics

  # Console whose puts goes through write, as some IO implementations do.
  class FakeConsole
    attr_reader :out

    def initialize = @out = +''

    def write(*args)
      (@out << args.join
       args.join.size)
    end

    def print(*) = write(*)
    def puts(*args) = write(Tap.text(:puts, args))
  end

  def setup
    Diagnostics.texts.clear
  end

  def test_text_of_puts_and_write
    assert_equal("a\nb\n", Tap.text(:puts, ['a', ["b\n"]]))
    assert_equal("\n", Tap.text(:puts, []))
    assert_equal('ab', Tap.text(:write, %w[a b]))
  end

  def test_each_text_is_handed_over_once_and_still_printed
    console = FakeConsole.new
    console.singleton_class.prepend(Tap)

    console.puts('Error: #<RuntimeError: x>')
    console.write('raw')

    assert_equal(["Error: #<RuntimeError: x>\n", 'raw'], Diagnostics.texts)
    assert_equal("Error: #<RuntimeError: x>\nraw", console.out)
  end

end
