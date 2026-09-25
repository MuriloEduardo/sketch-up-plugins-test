# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/events')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/params')
Sketchup.require('me_vray_toolkit/features/layout_sheets/output_path')
Sketchup.require('me_vray_toolkit/features/layout_sheets/page_geometry')
Sketchup.require('me_vray_toolkit/features/layout_sheets/scale')
Sketchup.require('me_vray_toolkit/features/layout_sheets/scene_filter')
Sketchup.require('me_vray_toolkit/features/layout_sheets/planner')
Sketchup.require('me_vray_toolkit/features/layout_sheets/strings')
Sketchup.require('me_vray_toolkit/features/layout_sheets/template_geometry')
Sketchup.require('me_vray_toolkit/features/layout_sheets/writer')
Sketchup.require('me_vray_toolkit/features/layout_sheets/dialog')
Sketchup.require('me_vray_toolkit/sketchup/model_data')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Creates a LayOut document with one sheet per scene of the saved model
      # (viewport + title block, ours or the user's template), an optional
      # sheet index and a PDF. Writes new files next to the model; never
      # changes the model or overwrites an existing file. The menu command
      # lives in {Dialog}.
      module LayoutSheets

        # A problem the user can fix; the message is already translated.
        class Error < StandardError; end

        # The typed action: same input from the menu, tests or an MCP tool.
        #
        # @param model [Sketchup::Model] saved (the viewports reference its file)
        # @param input [Hash] see SCHEMA
        # @return [Hash] `{ layout_path:, pdf_path:, sheets:, skipped: }`
        # @raise [Error] when the model has no usable scenes or is unsaved
        # @raise [ArgumentError] on invalid input
        def self.generate(model, input = {})
          params = Params.normalize(SCHEMA, input)
          raise Error, t(:layout_unavailable) unless Writer.available?
          raise Error, t(:not_saved) if model.path.empty?

          # Windows paths come with backslashes; LayOut and File accept '/'.
          model_path = model.path.tr('\\', '/')
          template = template_path(params[:template])

          planner, skipped = plan(model, model_path, params, template)
          sheets = planner.sheets
          base = OutputPath.base(model_path, exists: File.method(:exist?))
          layout_path = "#{base}.layout"
          pdf_path = params[:export_pdf] ? "#{base}.pdf" : nil
          Writer.new(model_path: model_path, render_mode: params[:render_mode], template: template)
                .write(sheets, paper: planner.paper_size, layout_path: layout_path, pdf_path: pdf_path)
          { layout_path: layout_path, pdf_path: pdf_path, sheets: sheets.map(&:name),
            skipped: skipped.map { |scene| scene[:name] }, }
        end

        # @return [Array(Planner, Array<Hash>)] the plan and the scenes left
        #   out because the saved file does not have them yet
        # @raise [Error] when no scene can get a sheet
        def self.plan(model, model_path, params, template)
          saved_scenes = Writer.scene_names(model_path)
          wanted = SceneFilter.matching(ModelData.scenes(model), params[:prefix])
          raise Error, no_scenes_message(params) if wanted.empty?

          usable, skipped = wanted.partition { |scene| saved_scenes.include?(scene[:name]) }
          raise Error, t(:skipped, scenes: names(skipped)) if usable.empty?

          geometry = template && TemplateGeometry.new(**Writer.template_facts(template))
          planner = Planner.new(scenes: usable, params: params, project: model.title,
                                date: Time.now.strftime(t(:date_format)), geometry: geometry)
          [planner, skipped]
        end

        # @param path [String] from the input; blank = no template
        # @return [String, nil]
        # @raise [Error] if it is not an existing .layout file
        def self.template_path(path)
          return nil if path.strip.empty?

          path = path.tr('\\', '/')
          raise Error, t(:template_not_found, path: path) unless File.file?(path) && path.downcase.end_with?('.layout')

          path
        end

        def self.no_scenes_message(params)
          params[:prefix].empty? ? t(:no_scenes) : t(:no_matching_scenes, prefix: params[:prefix])
        end

        def self.names(scenes)
          scenes.map { |scene| scene[:name] }.join(', ')
        end

        def self.t(key, **values)
          I18n.t(STRINGS, key, **values)
        end

        private_class_method :plan, :no_scenes_message, :names, :t

        Actions.register(
            name: 'generate_layout_sheets', group: :layout,
            description: 'Creates a LayOut document next to the saved model with one sheet per scene (viewport, ' \
                         'title block or the user\'s template, automatic scale for orthographic scenes), an ' \
                         'optional sheet index and a PDF. Never overwrites existing files. The model must be ' \
                         'saved; scenes added after the last save are skipped.',
            schema: SCHEMA
          ) { |params| generate(Sketchup.active_model, params) }

        Commands.register(id: :layout_sheets, title: -> { I18n.t(STRINGS, :menu_item) }, order: 15) { Dialog.run }

      end
    end
  end
end
