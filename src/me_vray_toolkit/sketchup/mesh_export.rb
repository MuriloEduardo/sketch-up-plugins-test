# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # A lightweight 3D snapshot of the visible model for web viewers (the
    # progress dashboard now, an MCP tool later): triangles grouped by
    # material color, plus the hard edges, in meters, Z up.
    #
    # Read-only: never changes the model.
    module MeshExport

      DEFAULT_COLOR = [230, 230, 225].freeze
      METERS_PER_INCH = 0.0254
      DECIMALS = 4

      # @param model [Sketchup::Model]
      # @param max_faces [Integer] stop after this many faces (big models)
      # @return [Hash] `{ materials: [{ name:, color:, alpha: }], meshes:
      #   [{ material:, positions: [x, y, z, ...], indices: [...] }],
      #   edges: [x1, y1, z1, x2, y2, z2, ...], faces:, truncated: }`
      def self.snapshot(model, max_faces: 200_000)
        state = { materials: {}, meshes: {}, edges: [], faces: 0, max_faces: max_faces, truncated: false }
        # The whole model, not the open edit context.
        walk(model.entities, IDENTITY, nil, state) # rubocop:disable SketchupSuggestions/ModelEntities
        materials = state[:materials].values
        {
          materials: materials.map { |entry| entry.except(:key) },
          meshes: state[:meshes].map { |key, mesh| mesh.merge(material: materials.index { |m| m[:key] == key }) },
          edges: state[:edges],
          faces: state[:faces],
          truncated: state[:truncated],
        }
      end

      IDENTITY = Geom::Transformation.new
      private_constant :IDENTITY

      def self.walk(entities, transformation, inherited, state)
        entities.each do |entity|
          next unless visible?(entity)
          break if state[:truncated]

          case entity
          when Sketchup::Face then add_face(entity, transformation, inherited, state)
          when Sketchup::Edge then add_edge(entity, transformation, state)
          when Sketchup::Group, Sketchup::ComponentInstance
            walk(entity.definition.entities, transformation * entity.transformation,
                 entity.material || inherited, state)
          end
        end
      end
      private_class_method :walk

      def self.visible?(entity)
        entity.visible? && (entity.layer.nil? || entity.layer.visible?)
      end
      private_class_method :visible?

      def self.add_face(face, transformation, inherited, state)
        if state[:faces] >= state[:max_faces]
          state[:truncated] = true
          return
        end
        state[:faces] += 1
        mesh = face.mesh(0)
        target = mesh_for(face.material || inherited, state)
        offset = target[:positions].size / 3
        mesh.points.each { |point| target[:positions].concat(coordinates(transformation * point)) }
        mesh.polygons.each do |polygon|
          target[:indices].concat(polygon.map { |index| index.abs - 1 + offset })
        end
      end
      private_class_method :add_face

      def self.add_edge(edge, transformation, state)
        return if edge.soft? || edge.smooth?

        state[:edges].concat(coordinates(transformation * edge.start.position))
        state[:edges].concat(coordinates(transformation * edge.end.position))
      end
      private_class_method :add_edge

      def self.mesh_for(material, state)
        key = material ? material.name : ''
        state[:materials][key] ||= {
          key: key,
          name: material ? material.display_name : '',
          color: material ? material.color.to_a.first(3) : DEFAULT_COLOR,
          alpha: material ? material.alpha : 1.0,
        }
        state[:meshes][key] ||= { positions: [], indices: [] }
      end
      private_class_method :mesh_for

      def self.coordinates(point)
        point.to_a.map { |value| (value * METERS_PER_INCH).round(DECIMALS) }
      end
      private_class_method :coordinates

    end
  end
end
