# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/vray/bridge')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Helpers shared by the tool groups (each group `extend`s it). Lengths
        # go out in meters.
        module Support

          METERS_PER_INCH = 0.0254

          def model
            Sketchup.active_model
          end

          # @param length [Numeric] inches
          # @return [Float] meters, 4 decimals
          def meters(length)
            (length.to_f * METERS_PER_INCH).round(4)
          end

          # @param bounds [Geom::BoundingBox]
          # @return [Array(Float, Float, Float), nil] width, depth, height in meters
          def size(bounds)
            bounds.empty? ? nil : [meters(bounds.width), meters(bounds.height), meters(bounds.depth)]
          end

          # Runs a change as one undo step; aborts it if the block fails.
          #
          # @param name [String] shown in Edit > Undo
          def change(name)
            model.start_operation(name, true)
            result = yield
            model.commit_operation
            result
          rescue StandardError
            model.abort_operation
            raise
          end

          # @raise [ArgumentError] (a readable tool error) without V-Ray
          def require_vray
            raise ArgumentError, 'V-Ray for SketchUp is not loaded in this SketchUp' unless VRayBridge.available?
          end

          # @return [Hash] render settings with the quality preset as a label
          def render_settings
            values = VRayBridge.render_settings
            values.merge(quality: VRayBridge::QualityPreset::LABELS[values.delete(:quality_preset)])
          end

          # @param entity [Sketchup::Drawingelement]
          # @return [Hash]
          def entity_summary(entity)
            summary = { type: entity.class.name.split('::').last, persistent_id: entity.persistent_id,
                        tag: entity.layer&.name, size_m: size(entity.bounds), }
            summary[:name] = entity.name if entity.respond_to?(:name) && !entity.name.to_s.empty?
            summary[:definition] = entity.definition.name if entity.respond_to?(:definition)
            summary[:material] = entity.material&.display_name if entity.respond_to?(:material)
            summary
          end

        end
      end
    end
  end
end
