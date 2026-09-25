# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Input of the {LayoutSheets.generate} action (see {Params}).
        SCHEMA = {
          prefix: { type: :string, default: '' },
          paper: { type: :enum, values: PageGeometry::PAPERS.keys, default: 'A3' },
          orientation: { type: :enum, values: %w[landscape portrait], default: 'landscape' },
          render_mode: { type: :enum, values: %w[raster hybrid vector], default: 'raster' },
          scale: { type: :enum, values: Scale::CHOICES, default: 'auto' },
          index_sheet: { type: :boolean, default: true },
          export_pdf: { type: :boolean, default: true },
        }.freeze

        # A text on a sheet; `x`/`y` is its top left corner in paper inches.
        Text = Struct.new(:text, :x, :y, :font_size, :bold, keyword_init: true)

        # One LayOut page. `scene` is nil for the index sheet; `viewport` is
        # the Box the scene is drawn in; `scale` is the "1:N" denominator for
        # orthographic scenes, nil otherwise.
        Sheet = Struct.new(:name, :scene, :viewport, :boxes, :texts, :scale, keyword_init: true)

        # Plans the pages of a LayOut document with one sheet per scene:
        # viewport, title block and an optional index sheet.
        #
        # Pure Ruby (needs {I18n}, {PageGeometry}, {Scale} and STRINGS loaded): unit
        # tested in the Docker toolchain. {Writer} turns the plan into a `.layout` file.
        class Planner

          PADDING = 0.12
          SECOND_LINE = 0.52
          INDEX_TOP = 0.5
          INDEX_LINE_HEIGHT = 0.25
          INDEX_COLUMN_WIDTH = 3.6

          # @return [Array<Hash>] the scenes that get a sheet, in model order
          attr_reader :scenes

          # @return [PageGeometry]
          attr_reader :geometry

          # @param scenes [Array<Hash>] `ModelData.scenes`:
          #   `{ name:, description:, perspective:, extent: }`
          # @param params [Hash] normalized with {SCHEMA}
          # @param project [String] shown in every title block (the model title)
          # @param date [String] shown in every title block
          def initialize(scenes:, params:, project:, date:)
            @params = params
            @project = project.to_s
            @date = date.to_s
            @geometry = PageGeometry.new(params[:paper], params[:orientation])
            @scenes = self.class.matching(scenes, params[:prefix])
          end

          # @param scenes [Array<Hash>]
          # @param prefix [String] comma separated name prefixes, any case;
          #   blank keeps every scene
          # @return [Array<Hash>]
          def self.matching(scenes, prefix)
            prefixes = prefix.to_s.split(',').map(&:strip).reject(&:empty?).map(&:downcase)
            return scenes if prefixes.empty?

            scenes.select { |scene| prefixes.any? { |start| scene[:name].to_s.downcase.start_with?(start) } }
          end

          # A free file name next to the model, so an existing document (and
          # the user's edits in it) is never overwritten.
          #
          # @param model_path [String] the saved `.skp`
          # @param exists [#call] receives a path, returns true if it is taken
          # @return [String] path without extension (add `.layout` / `.pdf`)
          def self.output_base(model_path, exists:)
            base = File.join(File.dirname(model_path), File.basename(model_path, '.*'))
            candidates = [base] + (2..999).map { |number| "#{base} (#{number})" }
            candidates.find { |candidate| %w[.layout .pdf].none? { |ext| exists.call("#{candidate}#{ext}") } } or
              raise ArgumentError, "no free file name for #{base}"
          end

          # @return [Array(Float, Float)] paper width and height, in inches
          def paper_size
            [geometry.width, geometry.height]
          end

          # @return [Array<Sheet>] empty when no scene matches the prefix
          def sheets
            return [] if @scenes.empty?

            first = @params[:index_sheet] ? 2 : 1
            total = @scenes.size + first - 1
            sheets = @scenes.map.with_index(first) { |scene, number| scene_sheet(scene, number, total) }
            sheets.unshift(index_sheet(sheets.map(&:name), total)) if @params[:index_sheet]
            sheets
          end

          private

          def scene_sheet(scene, number, total)
            scale = scale_for(scene)
            Sheet.new(name: scene[:name], scene: scene[:name], viewport: geometry.drawing_area,
                      boxes: geometry.title_block, scale: scale,
                      texts: title_block_texts(scene[:name], scene[:description], number, total, scale))
          end

          # Orthographic scenes only: LayOut cannot scale a perspective view.
          def scale_for(scene)
            return nil if scene[:perspective] || scene[:extent].nil?
            return Scale.parse(@params[:scale]) unless @params[:scale] == 'auto'

            Scale.fit(scene[:extent], geometry.drawing_area)
          end

          def index_sheet(scene_names, total)
            area = geometry.drawing_area
            heading = Text.new(text: t(:index_title), x: area.x, y: area.y, font_size: 16, bold: true)
            columns = index_columns([t(:index_title)] + scene_names, area)
            Sheet.new(name: t(:index_title), scene: nil, viewport: nil, boxes: geometry.title_block,
                      texts: [heading] + columns + title_block_texts(t(:index_title), '', 1, total))
          end

          # Lists every sheet ("01  Name"), wrapping into columns.
          def index_columns(names, area)
            top = area.y + INDEX_TOP
            per_column = [((area.y + area.height - top) / INDEX_LINE_HEIGHT).floor, 1].max
            lines = names.map.with_index(1) { |name, number| "#{format_number(number, names.size)}  #{name}" }
            lines.each_slice(per_column).map.with_index do |column, index|
              Text.new(text: column.join("\n"), x: area.x + (index * INDEX_COLUMN_WIDTH), y: top, font_size: 10,
                       bold: false)
            end
          end

          def title_block_texts(sheet_name, description, number, total, scale = nil)
            project, sheet = geometry.title_block
            sheet_line = t(:sheet_number, number: format_number(number, total), total: format_number(total, total))
            sheet_line += "  ·  #{t(:scale_label, scale: Scale.label(scale))}" if scale
            texts = [
              Text.new(text: @project, x: project.x + PADDING, y: project.y + PADDING, font_size: 14, bold: true),
              Text.new(text: sheet_name, x: sheet.x + PADDING, y: sheet.y + PADDING, font_size: 12, bold: true),
              Text.new(text: "#{sheet_line}  ·  #{@date}", x: sheet.x + PADDING, y: sheet.y + SECOND_LINE,
                       font_size: 9, bold: false),
              Text.new(text: description.to_s.strip, x: project.x + PADDING, y: project.y + SECOND_LINE,
                       font_size: 9, bold: false),
            ]
            texts.reject { |text| text.text.empty? }
          end

          def format_number(number, total)
            number.to_s.rjust([total.to_s.size, 2].max, '0')
          end

          def t(key, **values)
            I18n.t(STRINGS, key, **values)
          end

        end

      end
    end
  end
end
