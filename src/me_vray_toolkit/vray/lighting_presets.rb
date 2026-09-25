# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Starting points for common lighting situations: render parameters
      # ({RenderParameters} names) plus, for daylight, the time of day that
      # places the sun (V-Ray's sun follows SketchUp's shadow settings).
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module LightingPresets

        LIGHT_CACHE = { gi_enabled: true, gi_primary_engine: 'brute_force', gi_secondary_engine: 'light_cache' }.freeze
        PHYSICAL = { camera_exposure: 'physical', auto_exposure: 'off', auto_white_balance: 'off' }.freeze

        PRESETS = {
          'exterior_day' => {
            description: 'Sunny exterior around late morning: crisp sun, clear sky, neutral daylight camera.',
            time: { hour: 11, minute: 0 },
            parameters: PHYSICAL.merge(LIGHT_CACHE).merge(
                sun_enabled: true, sun_intensity: 1.0, sun_size: 1.0, sky_turbidity: 3.0,
                f_number: 8.0, shutter_speed: 300.0, iso: 100.0, white_balance_kelvin: 6500,
                highlight_burn: 1.0, environment_gi_override: false
              ),
          },
          'exterior_golden_hour' => {
            description: 'Low warm sun near sunset: long soft shadows, warm light kept warm.',
            time: { hour: 17, minute: 30 },
            parameters: PHYSICAL.merge(LIGHT_CACHE).merge(
                sun_enabled: true, sun_intensity: 1.0, sun_size: 3.0, sky_turbidity: 4.0,
                f_number: 8.0, shutter_speed: 100.0, iso: 100.0, white_balance_kelvin: 6500,
                highlight_burn: 0.8, environment_gi_override: false
              ),
          },
          'overcast' => {
            description: 'Cloudy day: very soft shadows, cooler diffuse light.',
            time: { hour: 13, minute: 0 },
            parameters: PHYSICAL.merge(LIGHT_CACHE).merge(
                sun_enabled: true, sun_intensity: 0.5, sun_size: 40.0, sky_turbidity: 10.0,
                f_number: 8.0, shutter_speed: 125.0, iso: 100.0, white_balance_kelvin: 7000,
                highlight_burn: 1.0, environment_gi_override: false
              ),
          },
          'interior_daylight' => {
            description: 'Room lit by windows: automatic exposure, highlights of the windows held back.',
            time: { hour: 10, minute: 0 },
            parameters: LIGHT_CACHE.merge(
                camera_exposure: 'physical', auto_exposure: 'histogram', auto_exposure_compensation: 0.0,
                auto_white_balance: 'off', sun_enabled: true, sun_intensity: 1.0, sun_size: 2.0,
                sky_turbidity: 3.0, white_balance_kelvin: 6500, highlight_burn: 0.6,
                environment_gi_override: false
              ),
          },
          'interior_artificial' => {
            description: 'Night interior lit by lamps: sun off, dark sky, automatic exposure, lamps kept ' \
                         'slightly warm (white balance 4000 K; automatic white balance made it too blue).',
            parameters: LIGHT_CACHE.merge(
                camera_exposure: 'physical', auto_exposure: 'histogram', auto_exposure_compensation: 0.0,
                auto_white_balance: 'off', white_balance_kelvin: 4000, sun_enabled: false, highlight_burn: 0.5,
                environment_gi_override: true, environment_gi_color: [20, 26, 45], environment_gi_multiplier: 0.3,
                background_sky: false, background_color: [3, 4, 10], background_multiplier: 0.05
              ),
          },
          'studio' => {
            description: 'Product/model shot: even gray ambient light, no sun, white background.',
            parameters: LIGHT_CACHE.merge(
                camera_exposure: 'physical', auto_exposure: 'histogram', auto_exposure_compensation: 0.0,
                auto_white_balance: 'off', sun_enabled: false, environment_gi_override: true,
                environment_gi_color: [200, 200, 200], environment_gi_multiplier: 1.0,
                background_color: [255, 255, 255], highlight_burn: 1.0
              ),
          },
        }.freeze

        # @param name [String]
        # @return [Hash] `{ description:, time:, parameters: }`
        # @raise [ArgumentError] unknown preset
        def self.fetch(name)
          PRESETS.fetch(name.to_s) {
            raise ArgumentError, "unknown lighting preset: #{name} (#{PRESETS.keys.join(', ')})"
          }
        end

        # @return [Array<Hash>] `{ name:, description:, time: }`
        def self.list
          PRESETS.map { |name, preset| { name: name, description: preset[:description], time: preset[:time] } }
        end

      end
    end
  end
end
