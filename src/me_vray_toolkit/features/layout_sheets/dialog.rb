# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/input_form')
Sketchup.require('me_vray_toolkit/core/params')

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets
        # The menu command: checks the model is saved, asks for the options
        # (and the template file) and reports the result. The work is done by
        # {LayoutSheets.generate}.
        module Dialog

          # Where the last template is remembered between sessions.
          PREFERENCES = 'MuriloEduardo_VRayToolkit_LayoutSheets'

          # The dialog's fields: the action's, with the template path replaced
          # by a choice (the file itself is picked in a file dialog).
          FORM_SCHEMA = { prefix: SCHEMA[:prefix],
                          title_block: { type: :enum, values: %w[toolkit template], default: 'toolkit' }, }
                        .merge(SCHEMA.except(:prefix, :template)).freeze

          # The last input, offered again by the dialog.
          @last_input = { template: Sketchup.read_default(PREFERENCES, 'template', '').to_s }

          # Asks for the options and generates the sheets for the active model.
          def self.run
            model = Sketchup.active_model
            return UI.messagebox(t(:layout_unavailable)) unless Writer.available?
            return unless ready_to_use?(model)

            input = ask
            return if input.nil?

            result = LayoutSheets.generate(model, input)
            UI.messagebox(summary(result), MB_MULTILINE, t(:title))
          rescue Error => error
            UI.messagebox(error.message)
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
            title_block = @last_input[:template].to_s.empty? ? 'toolkit' : 'template'
            answers = UI.inputbox(form.prompts, form.defaults(@last_input.merge(title_block: title_block)), form.lists,
                                  t(:title))
            return nil unless answers

            input = form.parse(answers)
            input[:template] = input.delete(:title_block) == 'template' ? choose_template : ''
            return nil if input[:template].nil?

            @last_input = Params.normalize(SCHEMA, input)
          end

          # @return [String, nil] nil when cancelled
          def self.choose_template
            last = @last_input[:template].to_s
            folder = last.empty? ? nil : File.dirname(last)
            path = UI.openpanel(t(:choose_template), folder, 'LayOut|*.layout||')
            Sketchup.write_default(PREFERENCES, 'template', path.tr('\\', '/')) if path
            path&.tr('\\', '/')
          end

          def self.form
            InputForm.new(
                FORM_SCHEMA,
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

          def self.t(key, **values)
            I18n.t(STRINGS, key, **values)
          end

          private_class_method :ask, :choose_template, :form, :summary, :t

        end
      end
    end
  end
end
