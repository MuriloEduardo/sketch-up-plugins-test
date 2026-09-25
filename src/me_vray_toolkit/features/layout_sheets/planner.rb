# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Input of the {LayoutSheets.generate} action (see {Params}).
        SCHEMA = {
          prefix: { type: :string, default: '',
                    description: 'Only scenes whose name starts with one of these comma separated prefixes ' \
                                 '(any case), e.g. "P., E."; empty = every scene', },
          paper: { type: :enum, values: PageGeometry::PAPERS.keys, default: 'A3',
                   description: 'Paper size when the toolkit draws the title block', },
          orientation: { type: :enum, values: %w[landscape portrait], default: 'landscape' },
          render_mode: { type: :enum, values: %w[raster hybrid vector], default: 'raster',
                         description: 'How LayOut draws the viewports; vector/hybrid are sharper but slower', },
          scale: { type: :enum, values: Scale::CHOICES, default: 'auto',
                   description: 'Scale of orthographic scenes; auto picks the largest standard scale that fits', },
          index_sheet: { type: :boolean, default: true, description: 'Add a first sheet listing all sheets' },
          export_pdf: { type: :boolean, default: true, description: 'Also export a PDF next to the model' },
          # A .layout whose frame and title block every sheet uses; empty = the
          # toolkit draws its own (then paper and orientation apply).
          template: { type: :string, default: '',
                      description: 'Path of a LayOut template (.layout) whose title block every sheet uses; ' \
                                   'empty = the toolkit draws its own', },
        }.freeze

        # A text on a sheet; `x`/`y` is its top left corner in paper inches.
        Text = Struct.new(:text, :x, :y, :font_size, :bold, keyword_init: true)

        # One LayOut page. `scene` is nil for the index sheet; `viewport` is
        # the Box the scene is drawn in; `scale` is the "1:N" denominator for
        # orthographic scenes, nil otherwise.
        Sheet = Struct.new(:name, :scene, :viewport, :boxes, :texts, :scale, keyword_init: true)

        # Plans the pages of a LayOut document with one sheet per scene:
        # viewport, title block and an optional index sheet. With a user
        # template ({TemplateGeometry}) the template draws the title block
        # and each viewport gets a caption (scene, description, scale).
        #
        # Pure Ruby (needs {I18n}, {PageGeometry}, {Scale}, {SceneFilter} and STRINGS loaded): unit
        # tested in the Docker toolchain. {Writer} turns the plan into a `.layout` file.
        class Planner

          PADDING = 0.12
          SECOND_LINE = 0.52
          INDEX_TOP = 0.5
          INDEX_LINE_HEIGHT = 0.25
          INDEX_COLUMN_WIDTH = 3.6
          CAPTION_HEIGHT = 0.35
          CAPTION_OFFSET = 0.1

          # @return [Array<Hash>] the scenes that get a sheet, in model order
          attr_reader :scenes

          # @return [PageGeometry, TemplateGeometry]
          attr_reader :geometry

          # @param scenes [Array<Hash>] `ModelData.scenes`:
          #   `{ name:, description:, perspective:, extent: }`
          # @param params [Hash] normalized with {SCHEMA}
          # @param project [String] shown in every title block (the model title)
          # @param date [String] shown in every title block
          # @param geometry [PageGeometry, TemplateGeometry, nil] nil = the
          #   toolkit's own sheet for `params[:paper]`
          def initialize(scenes:, params:, project:, date:, geometry: nil)
            @params = params
            @project = project.to_s
            @date = date.to_s
            @geometry = geometry || PageGeometry.new(params[:paper], params[:orientation])
            @scenes = SceneFilter.matching(scenes, params[:prefix])
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
            viewport = viewport_box
            scale = scale_for(scene, viewport)
            texts = if own_title_block?
                      title_block_texts(scene[:name], scene[:description], number, total, scale)
                    else
                      [caption(scene, scale)]
                    end
            Sheet.new(name: scene[:name], scene: scene[:name], viewport: viewport, boxes: geometry.title_block,
                      scale: scale, texts: texts)
          end

          def own_title_block?
            !geometry.title_block.empty?
          end

          # With a template, the bottom of the drawing area holds the caption.
          def viewport_box
            area = geometry.drawing_area
            return area if own_title_block?

            Box.new(x: area.x, y: area.y, width: area.width, height: area.height - CAPTION_HEIGHT)
          end

          def caption(scene, scale)
            area = geometry.drawing_area
            parts = [scene[:name], scene[:description].to_s.strip]
            parts << t(:scale_label, scale: Scale.label(scale)) if scale
            Text.new(text: parts.reject(&:empty?).join('  ·  '), x: area.x,
                     y: area.y + area.height - CAPTION_HEIGHT + CAPTION_OFFSET, font_size: 10, bold: true)
          end

          # Orthographic scenes only: LayOut cannot scale a perspective view.
          def scale_for(scene, viewport)
            return nil if scene[:perspective] || scene[:extent].nil?
            return Scale.parse(@params[:scale]) unless @params[:scale] == 'auto'

            Scale.fit(scene[:extent], viewport)
          end

          def index_sheet(scene_names, total)
            area = geometry.drawing_area
            heading = Text.new(text: t(:index_title), x: area.x, y: area.y, font_size: 16, bold: true)
            columns = index_columns([t(:index_title)] + scene_names, area)
            block = own_title_block? ? title_block_texts(t(:index_title), '', 1, total) : []
            Sheet.new(name: t(:index_title), scene: nil, viewport: nil, boxes: geometry.title_block,
                      texts: [heading] + columns + block)
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
