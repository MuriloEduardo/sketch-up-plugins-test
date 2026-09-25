# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/vray/material_parameters')
Sketchup.require('me_vray_toolkit/vray/plugin_path')
Sketchup.require('me_vray_toolkit/vray/quality_preset')
Sketchup.require('me_vray_toolkit/vray/render_parameter_definitions')
Sketchup.require('me_vray_toolkit/vray/render_parameters')

module MuriloEduardo
  module VRayToolkit
    # Thin, single point of contact with the V-Ray for SketchUp Ruby API
    # ("Script Access"). Everything that touches `::VRay` goes through here so
    # API changes between V-Ray versions only need fixing in one place.
    #
    # Knowledge base: docs/reference/vray-ruby-api.md
    module VRayBridge

      # Raised when V-Ray for SketchUp is not installed or not loaded.
      class NotAvailable < StandardError; end

      # Name fragment used to find V-Ray in SketchUp's Extension Manager.
      EXTENSION_NAME_PATTERN = /V-Ray/i

      # @return [Boolean] whether the V-Ray Ruby API is loaded.
      def self.available?
        defined?(::VRay::Context) ? true : false
      end

      # @return [SketchupExtension, nil] the V-Ray extension, if registered.
      def self.extension
        Sketchup.extensions.find { |extension| extension.name =~ EXTENSION_NAME_PATTERN }
      end

      # @return [String, nil] V-Ray version as shown in the Extension Manager.
      def self.version
        extension&.version
      end

      # @return [String, nil] V-Ray Ruby API version (`VRay::API_VERSION`,
      #   "5.04.02" on V-Ray 7.20), or nil when V-Ray is not loaded.
      def self.api_version
        defined?(::VRay::API_VERSION) ? ::VRay::API_VERSION : nil
      end

      # Returns the active V-Ray context.
      #
      # Activating the context installs V-Ray's SketchUp observers, which can
      # make heavy model edits several times slower until it is deactivated
      # (see {.deactivate}). Only call this when you actually need V-Ray.
      #
      # @return [Object] a `VRay::Context`
      # @raise [NotAvailable]
      def self.context
        raise NotAvailable, 'V-Ray for SketchUp is not loaded.' unless available?

        ::VRay::Context.active
      end

      # @return [Object] the active `VRay::Scene`
      def self.scene
        context.scene
      end

      # Runs the block inside a V-Ray scene transaction. Every write to scene
      # plugins must happen inside one.
      #
      # @yieldparam scene [Object] the active `VRay::Scene`
      # @return [Object] the block's return value
      def self.change
        current_scene = scene
        result = nil
        current_scene.change { result = yield(current_scene) }
        result
      end

      # Asks V-Ray's UI (Asset Editor etc.) to reload from the scene.
      #
      # `VRay.refresh_ui` (quoted on the Chaos forum) does not exist in
      # V-Ray 7.20, so this is currently a no-op there.
      def self.refresh_ui
        ::VRay.refresh_ui if ::VRay.respond_to?(:refresh_ui)
      end

      # Deactivates the V-Ray context, removing its observers. Restores full
      # model editing speed; V-Ray reactivates on its next use.
      #
      # Caution: scene changes not yet saved with the model are lost (the
      # context reloads from the .skp); verified on V-Ray 7.20.
      #
      # Caution: while the Asset Editor is open this can leave it in a bad
      # state (Chaos forum thread 118428).
      def self.deactivate
        return unless available?

        ::VRay::Context.active(false)&.delete
      end

      # Runs the block with an active V-Ray context and, if the context was not
      # active before, deactivates it afterwards so V-Ray's observers do not
      # keep slowing down modeling (see {.context}).
      #
      # @yield
      # @return [Object] the block's return value
      # @raise [NotAvailable]
      def self.with_context
        raise NotAvailable, 'V-Ray for SketchUp is not loaded.' unless available?

        was_active = !::VRay::Context.active(false).nil?
        begin
          yield
        ensure
          deactivate unless was_active
        end
      end

      # Plugin categories whose file parameters are outputs or caches (render
      # output, light cache files…), not assets the scene depends on.
      NON_ASSET_CATEGORIES = %i[settings file_type].freeze

      # Files referenced by the scene's assets (bitmaps, proxies, IES…).
      # `Plugin#each` yields `name, value, user_data, file_path, default`
      # (V-Ray 7.20 docs).
      #
      # @return [Array<Hash>] `{ plugin:, parameter:, path: }`, non-empty paths only
      def self.file_references
        references = []
        scene.each do |plugin|
          next if NON_ASSET_CATEGORIES.include?(plugin.category)

          plugin.each do |name, value, _user_data, file_path, _default|
            next unless file_path

            Array(value).grep(String).reject(&:empty?).each do |path|
              references << { plugin: plugin.name, parameter: name, path: path }
            end
          end
        end
        references
      end

      # @return [Hash{Symbol => Integer}] number of scene plugins per category
      #   (e.g. `:material`, `:light`, `:texture`)
      def self.plugin_counts
        counts = Hash.new(0)
        scene.each { |plugin| counts[plugin.category] += 1 }
        counts
      end

      # @return [Integer] current value of `/SettingsOptions`.`quality_preset`
      def self.quality_preset
        scene[QualityPreset::PLUGIN_NAME][QualityPreset::PARAMETER]
      end

      # @param value [Integer] see {QualityPreset::LABELS}
      def self.quality_preset=(value)
        QualityPreset.label_for(value) # Validates.
        change do |current_scene|
          current_scene[QualityPreset::PLUGIN_NAME][QualityPreset::PARAMETER] = value
        end
        refresh_ui
      end

      # Render settings we expose: plugin path and parameter (V-Ray 7.20).
      # Changes go into the .skp when the model is saved; deactivating the
      # context before that discards them (verified live).
      RENDER_SETTINGS = {
        width: ['/SettingsOutput', :img_width],
        height: ['/SettingsOutput', :img_height],
        quality_preset: ['/SettingsOptions', :quality_preset],
        time_limit_on: ['/SettingsOptions', :time_limit_on],
        time_limit_minutes: ['/SettingsOptions', :time_limit],
        noise_limit: ['/SettingsOptions', :progressive_noise_limit],
        gpu_engine: ['/SettingsOptions', :gpu_engine],
      }.freeze

      # @return [Hash{Symbol => Object}] keys of RENDER_SETTINGS
      def self.render_settings
        current_scene = scene
        RENDER_SETTINGS.transform_values { |(plugin, parameter)| current_scene[plugin][parameter] }
      end

      # Writes some of RENDER_SETTINGS into the scene. They reach the .skp
      # when the model is saved; do not {.deactivate} before that.
      #
      # @param values [Hash{Symbol => Object}]
      # @raise [ArgumentError] on an unknown key
      def self.update_render_settings(values)
        unknown = values.keys - RENDER_SETTINGS.keys
        raise ArgumentError, "unknown render setting(s): #{unknown.join(', ')}" unless unknown.empty?

        change do |current_scene|
          values.each do |key, value|
            plugin, parameter = RENDER_SETTINGS.fetch(key)
            current_scene[plugin][parameter] = value
          end
        end
        refresh_ui
      end

      # Starts a production render of the current view in a renderer of our
      # own, so the frame buffer and the model's saved settings stay as they
      # are. Returns at once; `listener` receives the renderer's events
      # (`on_state_changed`, `on_progress`), on SketchUp's main thread.
      #
      # @param model [Sketchup::Model]
      # @param width [Integer] pixels
      # @param height [Integer] pixels
      # @param max_minutes [Float, nil] progressive time limit, nil = settings
      # @param listener [Object]
      # @return [Object] the `VRay::VRayRenderer`
      def self.start_render(model:, width:, height:, listener:, max_minutes: nil)
        renderer = ::VRay::VRayRenderer.new
        ::VRay::ModelExporter.new(model: model, scene: scene, renderer: renderer).export_model(view: model.active_view)
        output = renderer.grep(:SettingsOutput).first
        output[:img_width] = width
        output[:img_height] = height
        sampler = renderer.grep(:SettingsImageSampler).first
        sampler[:progressive_maxTime] = max_minutes.to_f if sampler && max_minutes
        renderer.subscribe(listener)
        renderer.start
        renderer
      end

      # @param renderer [Object] from {.start_render}
      def self.stop_render(renderer)
        renderer.stop
      end

      # Stops sending the renderer's events to the listener.
      #
      # @param renderer [Object] from {.start_render}
      # @param listener [Object]
      def self.release_render(renderer, listener)
        renderer.unsubscribe(listener)
      end

      # @param renderer [Object] from {.start_render}
      # @return [Symbol] e.g. :rendering, :idleDone
      def self.render_state(renderer)
        renderer.state
      end

      # Saves the rendered image with the frame buffer's color corrections.
      #
      # @param renderer [Object] from {.start_render}
      # @param path [String] .png or .jpg
      # @return [Hash] `{ width:, height: }`
      def self.save_render(renderer, path)
        image = renderer.image(do_color_correct: true, strip_alpha: true)
        format = File.extname(path).casecmp?('.jpg') ? :jpeg : :png
        raise IOError, "V-Ray could not save #{path}" unless image.save(path, format: format)

        { width: image.width, height: image.height }
      end

      # Light kinds and the (internal, V-Ray 7.20) command that creates each.
      # The command adds a V-Ray light plugin and a SketchUp component
      # definition with the same name and no instance; we place the instance.
      LIGHT_COMMANDS = {
        rectangle: :create_rectangle_light, sphere: :create_sphere_light, spot: :create_spot_light,
        omni: :create_omni_light, ies: :create_ies_light, dome: :create_dome_light,
      }.freeze

      # Light parameters we expose (core layer; kept when the model is saved).
      # Sizes are in inches; u_size/v_size are half the rectangle sides.
      LIGHT_PARAMETERS = %i[enabled intensity color invisible u_size v_size radius intensity_multiplier].freeze

      # @return [Array<Hash>] `{ name:, type:, enabled:, intensity:, color: [r, g, b] }`
      #   (color 0-255) for every V-Ray light plugin
      def self.lights
        found = []
        scene.each do |plugin|
          next unless plugin.category == :light

          color = value_or_nil(plugin, :color)
          found << { name: plugin.name, type: plugin.type.to_s, enabled: value_or_nil(plugin, :enabled),
                     intensity: value_or_nil(plugin, :intensity), color: color && to_rgb(color), }
        end
        found
      end

      # Creates a light with V-Ray's own command (internal API).
      #
      # @param kind [Symbol] a key of LIGHT_COMMANDS
      # @param model [Sketchup::Model]
      # @param options [Hash] command options, e.g. `width:`, `height:`,
      #   `radius:` (inches) or `path:` (IES/HDRI file)
      # @return [Array(String, Sketchup::ComponentDefinition)] plugin name and
      #   the new definition to place
      # @raise [NotAvailable] when this V-Ray has no such command
      def self.create_light(kind, model:, **)
        command = LIGHT_COMMANDS.fetch(kind)
        unless defined?(::VRay::Command) && ::VRay::Command.respond_to?(command)
          raise NotAvailable, "This V-Ray cannot create #{kind} lights by script"
        end

        before_plugins = lights.map { |light| light[:name] }
        before_definitions = model.definitions.to_a
        ::VRay::Command.public_send(command, context: context, **)
        plugin = (lights.map { |light| light[:name] } - before_plugins).first
        definition = (model.definitions.to_a - before_definitions).first
        raise NotAvailable, "V-Ray did not create the #{kind} light" unless plugin

        [plugin, definition]
      end

      # @param name [String] light plugin name, e.g. "/Rectangle Light"
      # @param values [Hash] keys of LIGHT_PARAMETERS; `color` as [r, g, b] 0-255
      # @raise [ArgumentError] on an unknown light or parameter
      def self.update_light(name, values)
        unknown = values.keys - LIGHT_PARAMETERS
        raise ArgumentError, "unknown light parameter(s): #{unknown.join(', ')}" unless unknown.empty?

        change do |current_scene|
          plugin = current_scene[name] or raise ArgumentError, "no V-Ray light named #{name}"
          values.each do |key, value|
            plugin[key] = key == :color ? ::VRay::AColor.new(*value.map { |channel| channel / 255.0 }, 1.0) : value
          end
        end
      end

      def self.light_parameter?(plugin, parameter)
        found = false
        # VRay::Scene::Plugin#each yields parameters; it has no each_key.
        plugin.each { |name, *| found ||= name == parameter } # rubocop:disable Style/HashEachMethods
        found
      end
      private_class_method :light_parameter?

      def self.value_or_nil(plugin, parameter)
        light_parameter?(plugin, parameter) ? plugin[parameter] : nil
      end
      private_class_method :value_or_nil

      def self.to_rgb(color)
        color.to_a.first(3).map { |channel| (channel * 255).round.clamp(0, 255) }
      end
      private_class_method :to_rgb

      # Child plugin holding a VRayMtl's settings (see create_vray_material).
      VRAY_MTL_CHILD = 'VRay Mtl'

      # @return [Array<Hash>] `{ name:, type:, settings: }` for every material;
      #   type "sketchup" (plain SketchUp material) or "vray" (VRayMtl, with
      #   {MaterialParameters} settings)
      def self.vray_materials
        materials = []
        scene.each do |plugin|
          next unless plugin.category == :material

          brdf = brdf_of(plugin)
          materials << { name: plugin.name.delete_prefix('/'), type: brdf ? 'vray' : 'sketchup',
                         settings: brdf ? MaterialParameters.from_vray(read_parameters(brdf)) : nil, }
        end
        materials
      end

      # Creates a VRayMtl (MtlSingleBRDF + BRDFVRayMtl child); V-Ray adds the
      # SketchUp material with the same name (verified on 7.20).
      #
      # @param name [String] without the leading "/"
      # @param values [Hash] {MaterialParameters} friendly settings
      # @raise [ArgumentError] if the name is taken
      def self.create_vray_material(name, values)
        path = "/#{name}"
        change do |current_scene|
          raise ArgumentError, "a V-Ray material named #{name} already exists" if current_scene[path]

          material = current_scene.create(:MtlSingleBRDF, path)
          material[:brdf] = current_scene.create(:BRDFVRayMtl, "#{path}/#{VRAY_MTL_CHILD}")
        end
        update_vray_material(name, values) unless values.empty?
      end

      # @param name [String] VRayMtl name without "/"
      # @param values [Hash] {MaterialParameters} friendly settings
      # @raise [ArgumentError] if it is not a VRayMtl
      def self.update_vray_material(name, values)
        parameters = MaterialParameters.to_vray(values)
        change do |current_scene|
          material = current_scene["/#{name}"]
          brdf = material && brdf_of(material) or
            raise ArgumentError, "#{name} is not a V-Ray material (convert it first)"
          parameters.each do |parameter, value|
            brdf[parameter] = value.is_a?(Array) ? ::VRay::Color.new(*value) : value
          end
        end
      end

      # Turns a SketchUp material into a VRayMtl with V-Ray's own command
      # (internal API).
      #
      # @param name [String] SketchUp material name
      # @raise [NotAvailable] when this V-Ray cannot do it by script
      def self.convert_material_to_vray(name)
        unless defined?(::VRay::Command) && ::VRay::Command.respond_to?(:convert_material_to_vray)
          raise NotAvailable, 'This V-Ray cannot convert materials by script'
        end

        # The command wants the plugin name ("/Wood"); the BRDF child it
        # creates is "/Wood/BRDFVRayMtl" (verified on 7.20).
        ::VRay::Command.convert_material_to_vray(name: "/#{name}", context: context)
      end

      # The VRayMtl settings plugin of a material, whatever its name
      # ("/X/VRay Mtl" when we create it, "/X/BRDFVRayMtl" when V-Ray converts).
      #
      # @return [Object, nil] a BRDFVRayMtl plugin
      def self.brdf_of(material)
        return nil unless material.type == :MtlSingleBRDF

        brdf = material[:brdf]
        brdf if brdf.respond_to?(:type) && brdf.type == :BRDFVRayMtl
      end
      private_class_method :brdf_of

      def self.read_parameters(plugin)
        wanted = MaterialParameters::MAP.values.map(&:first)
        values = {}
        # VRay::Scene::Plugin#each yields parameters; it has no each_key.
        plugin.each do |name, value, *|
          next unless wanted.include?(name)

          values[name] = value.respond_to?(:to_a) ? value.to_a : value
        end
        values
      end
      private_class_method :read_parameters

      # @return [Hash{Array(String, Symbol) => Object}] every readable
      #   {RenderParameters} value; colors as arrays of floats 0-1
      def self.read_render_parameters
        current_scene = scene
        RenderParameters.readable.each_with_object({}) do |(plugin_name, parameter), readings|
          plugin = current_scene[plugin_name] or next
          value = plugin[parameter]
          readings[[plugin_name, parameter]] = value.respond_to?(:to_a) && !value.is_a?(Array) ? value.to_a : value
        end
      end

      # @param values [Hash{Symbol => Object}] {RenderParameters} friendly values
      # @raise [ArgumentError] on invalid values or a missing plugin
      def self.write_render_parameters(values)
        writes = RenderParameters.to_vray(values)
        change do |current_scene|
          writes.each do |plugin_name, parameter, raw|
            plugin = current_scene[plugin_name] or raise ArgumentError, "V-Ray scene has no #{plugin_name}"
            plugin[parameter] = coerce_like(plugin[parameter], raw)
          end
        end
      end

      # Keeps the stored type: some options are booleans in this V-Ray while
      # the plugin reference documents them as integers.
      def self.coerce_like(current, raw)
        return ::VRay::Color.new(*raw) if raw.is_a?(Array)
        return raw != 0 if [true, false].include?(current) && raw.is_a?(Integer)

        raw
      end
      private_class_method :coerce_like

      # Snapshot of the environment, useful for diagnostics and bug reports.
      #
      # @return [Hash{Symbol => Object}]
      def self.status
        vray_extension = extension
        {
          sketchup_version: Sketchup.version,
          ruby_version: RUBY_VERSION,
          platform: Sketchup.platform,
          vray_extension: vray_extension&.name,
          vray_version: vray_extension&.version,
          vray_api_version: api_version,
          vray_extension_loaded: vray_extension&.loaded?,
          vray_api_available: available?,
        }
      end

    end
  end
end
