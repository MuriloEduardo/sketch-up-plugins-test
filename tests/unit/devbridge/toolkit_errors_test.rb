# frozen_string_literal: true

require 'test_helper'
require_devbridge 'toolkit_errors'

class DevBridgeToolkitErrorsTest < Minitest::Test

  ToolkitErrors = MuriloEduardoDev::DevBridge::ToolkitErrors

  def test_action_failure_keeps_class_backtrace_and_context
    record = ToolkitErrors.to_record('action.failed', {
                                       name: 'render_scene', source: 'mcp', ms: 12, error: 'ArgumentError: bad scene',
                                       error_class: 'ArgumentError', backtrace: ['a.rb:1'],
                                     })

    assert_equal('ArgumentError', record[:kind])
    assert_equal('bad scene', record[:message])
    assert_equal(['a.rb:1'], record[:backtrace])
    assert_equal({ topic: 'action.failed', name: 'render_scene', source: 'mcp', ms: 12 }, record[:context])
  end

  def test_job_failure
    record = ToolkitErrors.to_record('job.failed',
                                     { id: 'j1', kind: 'render', error: 'V-Ray not ready', state: :failed })

    assert_equal(['JobFailed', 'render: V-Ray not ready'], record.values_at(:kind, :message))
    assert_equal({ id: 'j1', kind: 'render' }, record[:context][:job])
  end

  def test_other_topics_are_ignored
    assert_nil(ToolkitErrors.to_record('action.completed', {}))
  end

end
