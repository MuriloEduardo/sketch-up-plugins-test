# frozen_string_literal: true

require 'fileutils'
require 'json'

module MuriloEduardoDev
  module DevBridge
    # Runs the synced tests/sketchup suite with TestUp 2 inside SketchUp.
    module TestupRunner

      # @param workspace_root [String]
      # @param filter [String, nil] e.g. "TC_VRayBridge#" or "TC_VRayBridge#test_x"
      # @return [Hash] TestUp's CI JSON report under :report
      def self.run(workspace_root, filter)
        return { ok: false, error: 'TestUp 2 is not installed in this SketchUp.' } unless defined?(::TestUp::API)

        suite = File.join(workspace_root, 'tests', 'sketchup')
        return { ok: false, error: "no test suite at #{suite} (run make su-sync)" } unless File.directory?(suite)

        output = report_path(workspace_root)
        settings = { 'Output' => output }
        settings['Tests'] = [filter] if filter && !filter.empty?
        ::TestUp::API.run_suite_without_gui(suite, settings)
        flush_report(output)
        { ok: true, output: output, report: JSON.parse(File.read(output, encoding: 'bom|utf-8')) }
      end

      def self.report_path(workspace_root)
        results_dir = File.join(workspace_root, 'test-results')
        FileUtils.mkdir_p(results_dir)
        File.join(results_dir, "results-#{Time.now.strftime('%Y%m%d-%H%M%S')}.json")
      end
      private_class_method :report_path

      # TestUp's CIJsonReporter opens the output file and writes the report
      # without flushing or closing it, so the content may still be buffered.
      def self.flush_report(path)
        ObjectSpace.each_object(File) { |file| file.flush if !file.closed? && file.path == path }
      end
      private_class_method :flush_report

    end
  end
end
