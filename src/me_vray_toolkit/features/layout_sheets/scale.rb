# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Drawing scales for orthographic viewports, as the denominator N of
        # "1:N" (paper length = model length / N).
        #
        # Pure Ruby: unit tested in the Docker toolchain.
        module Scale

          # Standard architectural scales, largest drawing first.
          DENOMINATORS = [1, 2, 5, 10, 20, 25, 50, 75, 100, 125, 200, 250, 500, 1000, 2000, 5000].freeze

          # Values of the `scale` parameter.
          CHOICES = (['auto'] + [10, 20, 25, 50, 75, 100, 125, 200, 250, 500].map { |number| "1:#{number}" }).freeze

          # Share of the viewport the drawing may fill, leaving a small border.
          FILL = 0.9

          class << self

            # The largest standard scale at which the extent fits the box.
            #
            # @param extent [Array(Float, Float)] width and height seen by the
            #   camera, in model inches
            # @param box [Box] viewport, in paper inches
            # @return [Integer] denominator; the smallest scale if nothing fits
            def fit(extent, box)
              width, height = extent
              DENOMINATORS.find { |number| fits?(width / number, box.width) && fits?(height / number, box.height) } ||
                DENOMINATORS.last
            end

            # @param drawing [Float] paper inches
            # @param room [Float] paper inches
            def fits?(drawing, room)
              drawing <= room * FILL
            end

            # @param choice [String] "1:50"
            # @return [Integer] 50
            def parse(choice)
              Integer(choice.to_s.split(':').last)
            end

            # @param denominator [Integer]
            # @return [String] "1:50"
            def label(denominator)
              "1:#{denominator}"
            end

          end

        end

      end
    end
  end
end
