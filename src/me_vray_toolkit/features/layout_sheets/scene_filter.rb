# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module LayoutSheets

        # Picks scenes by name prefix. Pure Ruby: unit tested in the Docker
        # toolchain.
        module SceneFilter

          # @param scenes [Array<Hash>]
          # @param prefix [String] comma separated name prefixes, any case;
          #   blank keeps every scene
          # @return [Array<Hash>]
          def self.matching(scenes, prefix)
            prefixes = prefix.to_s.split(',').map(&:strip).reject(&:empty?).map(&:downcase)
            return scenes if prefixes.empty?

            scenes.select { |scene| prefixes.any? { |start| scene[:name].to_s.downcase.start_with?(start) } }
          end

        end

      end
    end
  end
end
