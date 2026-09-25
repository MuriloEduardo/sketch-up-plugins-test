# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Turns a {Planner} result into a `.layout` file (and optionally a PDF)
        # with the Ruby LayOut API, which runs inside SketchUp Pro.
        class Writer

          RENDER_MODES = { 'raster' => :RASTER_RENDER, 'hybrid' => :HYBRID_RENDER, 'vector' => :VECTOR_RENDER }.freeze

          # Size of the probe viewport used to read the scene list.
          PROBE_SIZE = 1.0

          # @return [Boolean] false in SketchUp Make/Free, which lack LayOut
          def self.available?
            defined?(Layout::Document) ? true : false
          end

          # Scenes as LayOut sees them in the saved file. Scenes added after
          # the last save are missing here.
          #
          # @param model_path [String] saved `.skp`
          # @return [Array<String>]
          def self.scene_names(model_path)
            probe = Layout::SketchUpModel.new(model_path, Geom::Bounds2d.new(0, 0, PROBE_SIZE, PROBE_SIZE))
            # The first entry is LayOut's "Last saved SketchUp View", not a scene.
            probe.scenes.drop(1)
          end

          # @param model_path [String] saved `.skp` the viewports reference
          # @param render_mode [String] a key of RENDER_MODES
          def initialize(model_path:, render_mode:)
            @model_path = model_path
            @render_mode = Layout::SketchUpModel.const_get(RENDER_MODES.fetch(render_mode))
            @document = Layout::Document.new
            @layer = @document.layers.active
          end

          # @param sheets [Array<Sheet>]
          # @param paper [Array(Float, Float)] width, height in inches
          # @param layout_path [String] must not exist yet
          # @param pdf_path [String, nil]
          def write(sheets, paper:, layout_path:, pdf_path: nil)
            setup_paper(paper)
            sheets.each_with_index do |sheet, index|
              page = index.zero? ? @document.pages.first : @document.pages.add
              page.name = sheet.name
              add_viewport(page, sheet) if sheet.scene
              sheet.boxes.each { |box| add_box(page, box) }
              sheet.texts.each { |text| add_text(page, text) }
            end
            @document.save(layout_path)
            @document.export(pdf_path) if pdf_path
          end

          private

          def setup_paper(paper)
            page_info = @document.page_info
            page_info.width, page_info.height = paper
            page_info.left_margin = page_info.right_margin = PageGeometry::MARGIN
            page_info.top_margin = page_info.bottom_margin = PageGeometry::MARGIN
          end

          def bounds(box)
            Geom::Bounds2d.new(box.x, box.y, box.width, box.height)
          end

          def add_viewport(page, sheet)
            viewport = Layout::SketchUpModel.new(@model_path, bounds(sheet.viewport))
            # Index 0 is "Last saved SketchUp View"; match scenes by name.
            viewport.current_scene = viewport.scenes.index(sheet.scene) ||
                                     raise(ArgumentError, "scene not in saved file: #{sheet.scene}")
            viewport.render_mode = @render_mode
            if sheet.scale
              viewport.scale = 1.0 / sheet.scale
              viewport.preserve_scale_on_resize = true
            end
            @document.add_entity(viewport, @layer, page)
            viewport.render if viewport.render_needed?
          end

          def add_box(page, box)
            rectangle = Layout::Rectangle.new(bounds(box))
            style = rectangle.style
            style.solid_filled = false
            rectangle.style = style
            @document.add_entity(rectangle, @layer, page)
          end

          def add_text(page, text)
            anchor = Geom::Point2d.new(text.x, text.y)
            entity = Layout::FormattedText.new(text.text, anchor, Layout::FormattedText::ANCHOR_TYPE_TOP_LEFT)
            style = entity.style
            style.font_size = text.font_size
            style.text_bold = text.bold
            entity.style = style
            @document.add_entity(entity, @layer, page)
          end

        end

      end
    end
  end
end
