# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/html')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/report_dialog')
Sketchup.require('me_vray_toolkit/features/scene_audit/analyzer')
Sketchup.require('me_vray_toolkit/features/scene_audit/report')
Sketchup.require('me_vray_toolkit/features/scene_audit/strings')
Sketchup.require('me_vray_toolkit/sketchup/model_data')
Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Read-only report of problems in the active model: missing V-Ray
      # files, oversized textures, unused materials. Never changes the model.
      module SceneAudit

        # Shows the audit of the active model.
        def self.run
          html = Report.render(analyze(Sketchup.active_model))
          ReportDialog.show(key: 'scene_audit', title: I18n.t(STRINGS, :title), html: html)
        end

        # @param model [Sketchup::Model]
        # @return [Analyzer]
        def self.analyze(model)
          Analyzer.new(**collect(model))
        end

        # Gathers the facts the {Analyzer} needs. Uses V-Ray only when it is
        # loaded, and leaves its context as it was.
        #
        # @param model [Sketchup::Model]
        # @return [Hash]
        def self.collect(model)
          data = {
            environment: VRayBridge.status,
            materials: ModelData.materials(model),
            file_references: [],
            plugin_counts: {},
          }
          return data unless VRayBridge.available?

          folder = ModelData.folder(model)
          VRayBridge.with_context do
            data[:file_references] = VRayBridge.file_references.map do |reference|
              reference.merge(exists: file_exists?(reference[:path], folder))
            end
            data[:plugin_counts] = VRayBridge.plugin_counts
          end
          data
        end

        # @param path [String] as stored by V-Ray (absolute or model-relative)
        # @param model_folder [String, nil]
        def self.file_exists?(path, model_folder)
          return true if File.exist?(path)

          !model_folder.nil? && File.exist?(File.join(model_folder, path))
        end

        Commands.register(id: :scene_audit, title: -> { I18n.t(STRINGS, :menu_item) }, order: 10) { run }

      end
    end
  end
end
