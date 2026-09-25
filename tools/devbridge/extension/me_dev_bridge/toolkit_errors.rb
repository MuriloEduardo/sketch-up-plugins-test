# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Turns the failures our extensions publish on their event bus into
    # error-audit entries.
    #
    # Pure Ruby (unit tested).
    module ToolkitErrors

      TOPICS = %w[action.failed command.failed job.failed].freeze

      # @param topic [String]
      # @param payload [Hash]
      # @return [Hash, nil] arguments for Diagnostics.record
      def self.to_record(topic, payload)
        case topic
        when 'job.failed'
          { source: 'toolkit', kind: 'JobFailed', message: "#{payload[:kind]}: #{payload[:error]}",
            context: { topic: topic, job: payload.slice(:id, :kind, :message, :details, :started_at) }, }
        when 'action.failed', 'command.failed'
          kind = payload[:error_class] || 'Error'
          { source: 'toolkit', kind: kind, message: payload[:error].to_s.delete_prefix("#{kind}: "),
            backtrace: payload[:backtrace] || [],
            context: { topic: topic }.merge(payload.except(:error, :error_class, :backtrace)), }
        end
      end

    end
  end
end
