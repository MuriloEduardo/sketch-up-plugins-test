# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/input_form')
Sketchup.require('me_vray_toolkit/core/params')
Sketchup.require('me_vray_toolkit/features/layout_sheets/page_geometry')
Sketchup.require('me_vray_toolkit/features/layout_sheets/scale')
Sketchup.require('me_vray_toolkit/features/layout_sheets/planner')
Sketchup.require('me_vray_toolkit/features/layout_sheets/strings')
Sketchup.require('me_vray_toolkit/features/layout_sheets/writer')
Sketchup.require('me_vray_toolkit/sketchup/model_data')

module MuriloEduardo
  module VRayToolkit
    module Features
      # Creates a LayOut document with one sheet per scene of the saved model
      # (viewport + title block), an optional sheet index and a PDF. Writes
      # new files next to the model; never changes the model or overwrites
      # an existing file.
      module LayoutSheets

        # A problem the user can fix; the message is already translated.
        class Error < StandardError; end

        # The last input in this session, offered again by the dialog.
        @last_input = {}

        # Asks for the options and generates the sheets for the active model.
        def self.run
          model = Sketchup.active_model
          return UI.messagebox(t(:layout_unavailable)) unless Writer.available?
          return unless ready_to_use?(model)

          input = ask
          return if input.nil?

          result = generate(model, input)
          UI.messagebox(summary(result), MB_MULTILINE, t(:title))
        rescue Error => error
          UI.messagebox(error.message)
        end

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

          saved_scenes = Writer.scene_names(model_path)
          wanted = Planner.matching(ModelData.scenes(model), params[:prefix])
          raise Error, no_scenes_message(params) if wanted.empty?

          usable, skipped = wanted.partition { |scene| saved_scenes.include?(scene[:name]) }
          planner = Planner.new(scenes: usable, params: params, project: model.title,
                                date: Time.now.strftime(t(:date_format)))
          sheets = planner.sheets
          raise Error, t(:skipped, scenes: names(skipped)) if sheets.empty?

          base = Planner.output_base(model_path, exists: File.method(:exist?))
          layout_path = "#{base}.layout"
          pdf_path = params[:export_pdf] ? "#{base}.pdf" : nil
          Writer.new(model_path: model_path, render_mode: params[:render_mode])
                .write(sheets, paper: planner.paper_size, layout_path: layout_path, pdf_path: pdf_path)
          { layout_path: layout_path, pdf_path: pdf_path, sheets: sheets.map(&:name),
            skipped: skipped.map { |scene| scene[:name] }, }
        end

        # @param model [Sketchup::Model]
        # @return [Boolean] false if the user must save first or cancelled
        def self.ready_to_use?(model)
          if model.path.empty?
            UI.messagebox(t(:not_saved))
            return false
          end
          return true unless model.modified?

          case UI.messagebox(t(:save_changes), MB_YESNOCANCEL)
          when IDYES then model.save
          when IDNO then true
          else false
          end
        end

        # @return [Hash, nil] nil when cancelled
        def self.ask
          answers = UI.inputbox(form.prompts, form.defaults(@last_input), form.lists, t(:title))
          return nil unless answers

          @last_input = Params.normalize(SCHEMA, form.parse(answers))
        end

        def self.form
          InputForm.new(
              SCHEMA,
              label: ->(name) { t(:"prompt_#{name}") },
              option_label: lambda do |name, value|
                case value
                when true then t(:answer_yes)
                when false then t(:answer_no)
                when 'auto' then t(:scale_auto)
                when *PageGeometry::PAPERS.keys, *Scale::CHOICES then value
                else t(:"#{name}_#{value}")
                end
              end
            )
        end

        def self.summary(result)
          lines = [t(:done, count: result[:sheets].size, layout: result[:layout_path])]
          lines << t(:done_pdf, pdf: result[:pdf_path]) if result[:pdf_path]
          lines << t(:skipped, scenes: result[:skipped].join(', ')) unless result[:skipped].empty?
          lines.join("\n\n")
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

        private_class_method :ask, :form, :summary, :no_scenes_message, :names, :t

        Commands.register(id: :layout_sheets, title: -> { I18n.t(STRINGS, :menu_item) }, order: 15) { run }

      end
    end
  end
end
