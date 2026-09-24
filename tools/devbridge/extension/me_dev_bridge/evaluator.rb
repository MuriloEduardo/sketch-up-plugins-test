# frozen_string_literal: true

require 'stringio'

module MuriloEduardoDev
  module DevBridge
    # Evaluates Ruby source with captured stdout. Arbitrary code execution by
    # design: this extension is DEVELOPMENT ONLY and never shipped to users.
    # Pure Ruby (unit tested in Docker).
    module Evaluator

      BACKTRACE_LINES = 20

      # @param code [String]
      # @param name [String] file name shown in backtraces
      # @param json [Boolean] return the raw value (caller serializes) instead of #inspect
      # @return [Hash]
      def self.run(code, name:, json: false)
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        result = evaluate(code, name, json)
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
        result.merge(stdout: output.string, seconds: elapsed.round(4))
      ensure
        $stdout = original_stdout
      end

      def self.evaluate(code, name, json)
        value = Object.new.instance_eval { binding }.eval(code, name)
        { ok: true, result: json ? value : value.inspect, result_class: value.class.name }
      rescue Exception => error # rubocop:disable Lint/RescueException
        # ScriptError (SyntaxError, LoadError) must reach the caller too.
        {
          ok: false,
          error: error.class.name,
          message: error.message,
          backtrace: Array(error.backtrace).first(BACKTRACE_LINES),
        }
      end
      private_class_method :evaluate

    end
  end
end
