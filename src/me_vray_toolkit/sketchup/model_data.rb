# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Read-only facts about a SketchUp model, as plain Hashes that pure code
    # (analyzers, reports) can use without touching the SketchUp API.
    module ModelData

      # @param model [Sketchup::Model]
      # @return [Array<Hash>] one per material:
      #   `{ name:, display_name:, uses:, texture_file:, texture_width:, texture_height: }`
      #   (texture fields are nil for untextured materials; sizes in pixels)
      def self.materials(model)
        usage = material_usage(model)
        model.materials.map do |material|
          texture = material.texture
          {
            name: material.name,
            display_name: material.display_name,
            uses: usage[material],
            texture_file: texture&.filename,
            texture_width: texture&.image_width,
            texture_height: texture&.image_height,
          }
        end
      end

      # Counts how many entities reference each material directly (faces,
      # back faces, groups and component instances). Each definition is
      # visited once, however many instances it has.
      #
      # @param model [Sketchup::Model]
      # @return [Hash{Sketchup::Material => Integer}] default 0
      def self.material_usage(model)
        usage = Hash.new(0)
        # The whole model's root, not the open edit context: usage is global.
        count_entities(model.entities, usage) # rubocop:disable SketchupSuggestions/ModelEntities
        model.definitions.each do |definition|
          count_entities(definition.entities, usage) unless definition.image?
        end
        usage
      end

      def self.count_entities(entities, usage)
        entities.each do |entity|
          case entity
          when Sketchup::Face
            usage[entity.material] += 1 if entity.material
            usage[entity.back_material] += 1 if entity.back_material
          when Sketchup::Group, Sketchup::ComponentInstance
            usage[entity.material] += 1 if entity.material
          end
        end
      end
      private_class_method :count_entities

      # @param model [Sketchup::Model]
      # @return [Array<Hash>] one per scene, in tab order: `{ name:, description: }`
      def self.scenes(model)
        model.pages.map { |page| { name: page.name, description: page.description } }
      end

      # @param model [Sketchup::Model]
      # @return [String, nil] folder of the saved model, nil if never saved
      def self.folder(model)
        model.path.empty? ? nil : File.dirname(model.path)
      end

    end
  end
end
