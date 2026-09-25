# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # A rectangle in paper inches, origin at the top left corner of the
        # page and y growing downwards (LayOut's paper space).
        Box = Struct.new(:x, :y, :width, :height, keyword_init: true)

        # Where things go on a sheet: drawing area on top, title block along
        # the bottom (project column on the left, sheet column on the right).
        #
        # Pure Ruby: unit tested in the Docker toolchain.
        class PageGeometry

          # Portrait width x height, in inches.
          PAPERS = {
            'A4' => [8.268, 11.693],
            'A3' => [11.693, 16.535],
            'A2' => [16.535, 23.386],
            'A1' => [23.386, 33.110],
            'Letter' => [8.5, 11.0],
            'Tabloid' => [11.0, 17.0],
          }.freeze

          MARGIN = 0.4
          GAP = 0.15
          TITLE_BLOCK_HEIGHT = 0.9
          # Share of the title block width used by the project column.
          PROJECT_COLUMN = 0.6

          # @return [Float]
          attr_reader :width, :height

          # @param paper [String] a key of PAPERS
          # @param orientation [String] "landscape" or "portrait"
          def initialize(paper, orientation)
            short, long = PAPERS.fetch(paper)
            @width, @height = orientation == 'landscape' ? [long, short] : [short, long]
          end

          # @return [Box] inside the margins, above the title block
          def drawing_area
            Box.new(x: MARGIN, y: MARGIN, width: inner_width,
                    height: height - (2 * MARGIN) - TITLE_BLOCK_HEIGHT - GAP)
          end

          # @return [Array(Box, Box)] project column, sheet column
          def title_block
            left = (inner_width * PROJECT_COLUMN).round(3)
            top = height - MARGIN - TITLE_BLOCK_HEIGHT
            [
              Box.new(x: MARGIN, y: top, width: left, height: TITLE_BLOCK_HEIGHT),
              Box.new(x: MARGIN + left, y: top, width: (inner_width - left).round(3), height: TITLE_BLOCK_HEIGHT),
            ]
          end

          private

          def inner_width
            width - (2 * MARGIN)
          end

        end

      end
    end
  end
end
