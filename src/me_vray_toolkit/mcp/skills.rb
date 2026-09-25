# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/mcp/prompts')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # The workflows ("skills") this server offers as MCP prompts.
      module Skills

        Prompts.register(
            name: 'render_setup', title: 'Set up and render with V-Ray',
            description: 'Checks V-Ray, makes a quick test render, reviews it and makes the final render.',
            arguments: [
              { name: 'scene', description: 'Scene to render (empty = current view)' },
              { name: 'quality', description: 'Low, Medium, High… (empty = keep the model setting)' },
              { name: 'size', description: 'Final size in pixels, e.g. 1920x1080 (empty = model setting)' },
            ]
          ) do |args|
          <<~TEXT
            Render #{args['scene'].to_s.empty? ? 'the current view' : "the scene \"#{args['scene']}\""} with V-Ray in SketchUp.
            1. Call vray_status. If V-Ray is not available, stop and tell me.
            2. Call list_scenes and capture_view to see what will be rendered; if a scene was named, check it exists.
            3. #{args['quality'].to_s.empty? ? 'Keep the quality preset' : "Call set_render_settings with quality \"#{args['quality']}\""}.
            4. Make a quick test render with render_scene (640x360, max_minutes 0.5). Poll get_render_status
               every 10 seconds until it is done, failed or cancelled.
            5. Look at the test image: exposure, composition, missing textures or lights. If something is clearly
               wrong, explain it and ask me before changing the model.
            6. Make the final render with render_scene#{" at #{args['size']}" unless args['size'].to_s.empty?} and a
               time limit that fits (start with 3 minutes), poll until done and show me the result and file path.
          TEXT
        end

        Prompts.register(
            name: 'presentation_package', title: 'Presentation package',
            description: 'Renders the chosen scenes and builds LayOut sheets and a PDF for a client presentation.',
            arguments: [
              { name: 'scenes', description: 'Comma separated scene name prefixes (empty = every scene)' },
              { name: 'template', description: 'Path of a LayOut template (.layout) with the office title block' },
            ]
          ) do |args|
          <<~TEXT
            Prepare a presentation package from the open SketchUp model.
            1. Call model_info; the model must be saved (LayOut references the file). If it is not, ask me to save it.
            2. Call list_scenes and pick the scenes#{" whose names start with #{args['scenes']}" unless args['scenes'].to_s.empty?}.
            3. For each perspective scene, render it with render_scene (1600x900, max_minutes 3), one at a time,
               polling get_render_status until done. Keep the file paths.
            4. Call generate_layout_sheets#{" with template \"#{args['template']}\"" unless args['template'].to_s.empty?} and export_pdf true.
            5. Give me a short summary: sheets created, renders with their paths, anything skipped and why.
          TEXT
        end

        Prompts.register(
            name: 'scene_review', title: 'Review the model',
            description: 'Audits the model and the view and suggests improvements before rendering or sheets.'
          ) do |_args|
          <<~TEXT
            Review the SketchUp model open on my computer before I render or make sheets.
            1. Call model_info, audit_scene, list_scenes, list_materials and list_tags.
            2. Call capture_view to see the current view.
            3. Report, most important first: files V-Ray cannot find, heavy textures, unused materials, scenes
               without a clear purpose, hidden tags that may hide needed geometry.
            4. Suggest concrete next steps. Do not change the model; ask me first.
          TEXT
        end

      end
    end
  end
end
