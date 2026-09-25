# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Where an error happened: machine, versions and the open model, stored
    # with every entry of the error audit. Never raises.
    module ErrorContext

      # @return [Hash] machine:, sketchup_version:, model_name:
      def self.fields
        { machine: ENV.fetch('COMPUTERNAME', nil), sketchup_version: Sketchup.version.to_s, model_name: model_name }
      rescue StandardError
        {}
      end

      # @return [Hash] stored under `context`
      def self.environment
        vray = Sketchup.extensions.find { |extension| extension.name =~ /V-Ray/i }
        { bridge_version: BRIDGE_VERSION, ruby_version: RUBY_VERSION, vray_version: vray&.version }
      rescue StandardError
        {}
      end

      # @return [String, nil] file name of the open model, or its title if unsaved
      def self.model_name
        model = Sketchup.active_model
        return unless model

        model.path.to_s.empty? ? model.title : File.basename(model.path.to_s)
      end

    end
  end
end
