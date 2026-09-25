# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # Tools for scenes (SketchUp "pages").
        module Scenes

          extend Support

          def self.describe(page)
            { name: page.name, description: page.description, perspective: page.camera.perspective?,
              selected: page == model.pages.selected_page, }
          end

          def self.find(name)
            model.pages[name] or raise ArgumentError, "no scene named #{name}"
          end

          NAME = { type: :string, required: true, description: 'Scene name' }.freeze

          Actions.register(
              name: 'list_scenes', group: :scenes, read_only: true,
              description: 'Scenes of the open model in tab order, with description, camera type and which one ' \
                           'is active.'
            ) { { scenes: model.pages.map { |page| describe(page) } } }

          Actions.register(
              name: 'create_scene', group: :scenes,
              description: 'Adds a scene that remembers the current view (camera, style, visible tags). One undo step.',
              schema: { name: NAME, description: { type: :string, default: '', description: 'Scene description' } }
            ) do |params|
            raise ArgumentError, "a scene named #{params[:name]} already exists" if model.pages[params[:name]]

            page = change('Create Scene') { model.pages.add(params[:name]) }
            page.description = params[:description]
            describe(page)
          end

          Actions.register(
              name: 'activate_scene', group: :scenes, idempotent: true,
              description: 'Switches the view to a scene (camera, style and tag visibility), like clicking its tab.',
              schema: { name: NAME }
            ) do |params|
            page = find(params[:name])
            model.pages.selected_page = page
            describe(page)
          end

        end
      end
    end
  end
end
