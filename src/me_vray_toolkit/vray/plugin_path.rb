# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Helpers for V-Ray scene plugin names.
      #
      # V-Ray for SketchUp names plugins like absolute paths and expresses
      # ownership through nesting: a child plugin must live under its parent,
      # e.g. `/My Material/VRay Mtl`. Creating a child outside its parent's
      # namespace produces assets the Asset Editor does not recognize
      # (Chaos forum thread 118132).
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module PluginPath

        SEPARATOR = '/'

        # @param segments [Array<String>] e.g. ["My Material", "VRay Mtl"]
        # @return [String] e.g. "/My Material/VRay Mtl"
        # @raise [ArgumentError] on empty segments or segments containing "/".
        def self.join(*segments)
          raise ArgumentError, 'at least one segment is required' if segments.empty?

          segments.each do |segment|
            text = segment.to_s
            raise ArgumentError, 'segments must not be empty' if text.empty?
            raise ArgumentError, "segment must not contain '/': #{text.inspect}" if text.include?(SEPARATOR)
          end
          SEPARATOR + segments.join(SEPARATOR)
        end

        # @param path [String] e.g. "/My Material/VRay Mtl"
        # @return [Array<String>] e.g. ["My Material", "VRay Mtl"]
        def self.split(path)
          path.to_s.split(SEPARATOR).reject(&:empty?)
        end

        # @param path [String]
        # @return [String, nil] parent path, or nil for a top-level plugin.
        def self.parent(path)
          segments = split(path)
          return nil if segments.size <= 1

          join(*segments[0...-1])
        end

        # @param parent [String] parent plugin path
        # @param name [String] child name
        # @return [String]
        def self.child(parent, name)
          join(*split(parent), name)
        end

        # Name of the V-Ray scene plugin that backs a SketchUp material.
        #
        # @param material_name [String] SketchUp material display name.
        # @return [String]
        def self.for_material(material_name)
          join(material_name)
        end

      end
    end
  end
end
