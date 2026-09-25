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

          # What {TemplateGeometry} needs from a template: paper, margins
          # and the bounds of what its sheet page shows.
          #
          # @param template_path [String] `.layout`
          # @return [Hash] `{ width:, height:, margins:, boxes: }`
          def self.template_facts(template_path)
            document = Layout::Document.open(template_path)
            info = document.page_info
            page = sheet_page(document)
            visible = page.entities.select { |entity| page.layer_visible?(entity.layer_instance.definition) }
            {
              width: info.width, height: info.height,
              margins: { left: info.left_margin, top: info.top_margin, right: info.right_margin,
                         bottom: info.bottom_margin, },
              boxes: visible.map { |entity| box(entity.bounds) },
            }
          end

          # The page every sheet copies: the last page showing a shared
          # layer (templates show their title block on "inside" pages that
          # way and hide it on the cover), else the last page.
          #
          # @param document [Layout::Document]
          # @return [Layout::Page]
          def self.sheet_page(document)
            shared = document.layers.select(&:shared?)
            pages = document.pages.to_a
            pages.reverse.find { |page| shared.any? { |layer| page.layer_visible?(layer) } } || pages.last
          end

          # @param bounds [Geom::Bounds2d]
          # @return [Box]
          def self.box(bounds)
            Box.new(x: bounds.upper_left.x, y: bounds.upper_left.y, width: bounds.width, height: bounds.height)
          end

          # @param model_path [String] saved `.skp` the viewports reference
          # @param render_mode [String] a key of RENDER_MODES
          # @param template [String, nil] `.layout` to start from
          def initialize(model_path:, render_mode:, template: nil)
            @model_path = model_path
            @render_mode = Layout::SketchUpModel.const_get(RENDER_MODES.fetch(render_mode))
            @template = template
            @document = template ? Layout::Document.new(template) : Layout::Document.new
            @first_page = template ? keep_only_sheet_page : @document.pages.first
            @layer = content_layer
          end

          # @param sheets [Array<Sheet>]
          # @param paper [Array(Float, Float)] width, height in inches; a
          #   template keeps its own
          # @param layout_path [String] must not exist yet
          # @param pdf_path [String, nil]
          def write(sheets, paper:, layout_path:, pdf_path: nil)
            setup_paper(paper) unless @template
            sheets.each_with_index do |sheet, index|
              page = index.zero? ? @first_page : @document.pages.add
              page.name = sheet.name
              add_viewport(page, sheet) if sheet.scene
              sheet.boxes.each { |box| add_box(page, box) }
              sheet.texts.each { |text| add_text(page, text) }
            end
            @document.save(layout_path)
            @document.export(pdf_path) if pdf_path
          end

          private

          # Drops the cover and other pages; new pages repeat the template's
          # shared layers (frame and title block).
          def keep_only_sheet_page
            page = self.class.sheet_page(@document)
            # Layout::Page defines == but not eql?/hash, so Array#- keeps it.
            @document.pages.to_a.reject { |other| other == page }.each { |other| @document.pages.remove(other) }
            page
          end

          # Our entities go on a normal, editable layer, never on a shared one
          # (they would repeat on every page).
          def content_layer
            layers = @document.layers
            usable = ->(layer) { !layer.shared? && !layer.locked? }
            return layers.active if usable.call(layers.active)

            layers.find(&usable) || layers.add('V-Ray Toolkit')
          end

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
