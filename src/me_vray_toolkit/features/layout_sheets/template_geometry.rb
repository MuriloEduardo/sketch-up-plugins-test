# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Where drawings fit on a sheet of the user's LayOut template: inside
        # its frame (the one rectangle covering most of the page, when there
        # is one; else the page margins), in the largest area no part of the
        # title block crosses. The template draws its own title block.
        #
        # Same interface as {PageGeometry}. Pure Ruby: unit tested in the
        # Docker toolchain; {Writer.template_facts} reads the template.
        class TemplateGeometry

          # A rectangle covering at least this share of the page is a frame.
          FRAME_SHARE = 0.5
          # Space kept between the drawing and the frame or title block.
          PADDING = 0.15

          # @return [Float]
          attr_reader :width, :height

          # @param width [Float] paper width, inches
          # @param height [Float] paper height, inches
          # @param margins [Hash{Symbol => Float}] `left:, top:, right:, bottom:`
          # @param boxes [Array<Box>] bounds of what is visible on the
          #   template's sheet page (frame, title block, logos, texts)
          def initialize(width:, height:, margins:, boxes:)
            @width = width
            @height = height
            frame = boxes.select { |box| area(box) >= FRAME_SHARE * width * height }.max_by { |box| area(box) }
            @container = frame || margin_box(margins)
            @obstacles = boxes.reject { |box| box.equal?(frame) }
          end

          # @return [Box] largest free area, inset by PADDING
          def drawing_area
            free = largest_free_area
            Box.new(x: free.x + PADDING, y: free.y + PADDING,
                    width: free.width - (2 * PADDING), height: free.height - (2 * PADDING))
          end

          # @return [Array<Box>] none: the template brings its own
          def title_block
            []
          end

          private

          def margin_box(margins)
            Box.new(x: margins[:left], y: margins[:top], width: width - margins[:left] - margins[:right],
                    height: height - margins[:top] - margins[:bottom])
          end

          def area(box)
            box.width * box.height
          end

          def right(box)
            box.x + box.width
          end

          def bottom(box)
            box.y + box.height
          end

          # Tries every pair of vertical edges (container and obstacle
          # sides) and, between them, every vertical gap the obstacles leave.
          def largest_free_area
            left_edge = @container.x
            right_edge = right(@container)
            edges = ([left_edge, right_edge] + @obstacles.flat_map { |box| [box.x, right(box)] })
                    .grep(left_edge..right_edge).uniq.sort
            candidates = edges.combination(2).flat_map do |start, finish|
              gaps(start, finish).map { |top, low| Box.new(x: start, y: top, width: finish - start, height: low - top) }
            end
            candidates.max_by { |box| area(box) } || @container
          end

          # Free vertical intervals of the container between x = start..finish.
          def gaps(start, finish)
            blocking = @obstacles.select { |box| box.x < finish && right(box) > start }
                                 .map { |box| [box.y, bottom(box)] }.sort
            cursor = @container.y
            found = []
            blocking.each do |top, low|
              found << [cursor, [top, bottom(@container)].min] if top > cursor
              cursor = [cursor, low].max
            end
            found << [cursor, bottom(@container)] if cursor < bottom(@container)
            found.select { |top, low| low > top }
          end

        end

      end
    end
  end
end
