# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Names the generated files. Pure Ruby: unit tested in the Docker
        # toolchain.
        module OutputPath

          EXTENSIONS = %w[.layout .pdf].freeze
          MAX_COPIES = 999

          # A free file name next to the model, so an existing document (and
          # the user's edits in it) is never overwritten.
          #
          # @param model_path [String] the saved `.skp`
          # @param exists [#call] receives a path, returns true if it is taken
          # @return [String] path without extension (add `.layout` / `.pdf`)
          def self.base(model_path, exists:)
            base = File.join(File.dirname(model_path), File.basename(model_path, '.*'))
            candidates = [base] + (2..MAX_COPIES).map { |number| "#{base} (#{number})" }
            candidates.find { |candidate| EXTENSIONS.none? { |ext| exists.call("#{candidate}#{ext}") } } or
              raise ArgumentError, "no free file name for #{base}"
          end

        end

      end
    end
  end
end
