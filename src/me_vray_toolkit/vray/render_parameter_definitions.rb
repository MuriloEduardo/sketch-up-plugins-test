# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module VRayBridge
      # Data for {RenderParameters}: friendly name → V-Ray plugin, parameter,
      # type, range and description (V-Ray plugin reference; V-Ray 7.20).
      module RenderParameterDefinitions

        CAMERA = '/CameraPhysical'
        AUTO = '/SettingsCamera'
        MAPPING = '/SettingsColorMapping'
        GI = '/SettingsGI'
        SUN = '/SunLight'
        ENVIRONMENT = '/SettingsEnvironment'

        # Parameter definitions. type: :number, :integer, :boolean, :enum
        # (values: name => V-Ray int), :rgb (0-255 ↔ Color), :kelvin (color
        # temperature → Color), :length (meters ↔ inches).
        DEFINITIONS = {
          camera_exposure: { plugin: CAMERA, parameter: :exposure, type: :enum, group: :camera,
                             values: { 'off' => 0, 'physical' => 1, 'exposure_value' => 2 },
                             description: 'Camera exposure: physical (f-number, shutter, ISO) or a single EV', },
          exposure_value: { plugin: CAMERA, parameter: :exposure_value, type: :number, range: -10.0..24.0,
                            group: :camera,
                            description: 'EV when camera_exposure is exposure_value (higher = darker)', },
          f_number: { plugin: CAMERA, parameter: :f_number, type: :number, range: 0.5..64.0, group: :camera,
                      description: 'Aperture f-number (higher = darker, deeper focus)', },
          shutter_speed: { plugin: CAMERA, parameter: :shutter_speed, type: :number, range: 0.01..100_000.0,
                           group: :camera, description: 'Shutter 1/x seconds: 250 = 1/250 s (higher = darker)', },
          iso: { plugin: CAMERA, parameter: :ISO, type: :number, range: 1.0..204_800.0, group: :camera,
                 description: 'Film sensitivity (higher = brighter)', },
          white_balance_kelvin: { plugin: CAMERA, parameter: :white_balance, type: :kelvin, range: 1000..40_000,
                                  group: :camera, write_only: true,
                                  description: 'White balance as color temperature: 6500 neutral daylight, ' \
                                               '3000-4000 neutralizes warm lamps', },
          white_balance: { plugin: CAMERA, parameter: :white_balance, type: :rgb, group: :camera,
                           description: 'White balance color, RGB 0-255 (white = none)', },
          vignetting: { plugin: CAMERA, parameter: :vignetting, type: :number, range: 0.0..1.0, group: :camera,
                        description: 'Darker image corners 0-1', },
          auto_exposure: { plugin: AUTO, parameter: :auto_exposure, type: :enum, group: :auto,
                           values: { 'off' => 0, 'center_weighted' => 1, 'histogram' => 2 },
                           description: 'Automatic exposure (needs light cache GI)', },
          auto_exposure_compensation: { plugin: AUTO, parameter: :auto_exposure_compensation, type: :number,
                                        range: -10.0..10.0, group: :auto,
                                        description: 'Auto exposure correction in f-stops (+1 twice as bright)', },
          auto_white_balance: { plugin: AUTO, parameter: :auto_white_balance, type: :enum, group: :auto,
                                values: { 'off' => 0, 'temperature' => 1, 'rgb' => 2 },
                                description: 'Automatic white balance (needs light cache GI)', },
          color_mapping: { plugin: MAPPING, parameter: :type, type: :enum, group: :tone_mapping,
                           values: { 'linear' => 0, 'exponential' => 1, 'hsv_exponential' => 2,
                                     'intensity_exponential' => 3, 'gamma' => 4, 'intensity_gamma' => 5,
                                     'reinhard' => 6, },
                           description: 'Tone mapping curve (reinhard is the V-Ray for SketchUp default)', },
          highlight_burn: { plugin: MAPPING, parameter: :bright_mult, type: :number, range: 0.0..1.0,
                            group: :tone_mapping,
                            description: 'Reinhard burn: 1 = no compression, lower keeps windows and lamps ' \
                                         'from blowing out', },
          mapping_multiplier: { plugin: MAPPING, parameter: :dark_mult, type: :number, range: 0.0..100.0,
                                group: :tone_mapping, description: 'Overall brightness multiplier of the mapping', },
          gamma: { plugin: MAPPING, parameter: :gamma, type: :number, range: 0.2..5.0, group: :tone_mapping,
                   description: 'Mapping gamma (2.2 standard)', },
          gi_enabled: { plugin: GI, parameter: :on, type: :boolean, group: :gi,
                        description: 'Global illumination (bounced light)', },
          gi_primary_engine: { plugin: GI, parameter: :primary_engine, type: :enum, group: :gi,
                               values: { 'irradiance_map' => 0, 'brute_force' => 2 },
                               description: 'GI engine for the first bounce', },
          gi_secondary_engine: { plugin: GI, parameter: :secondary_engine, type: :enum, group: :gi,
                                 values: { 'none' => 0, 'brute_force' => 2, 'light_cache' => 3 },
                                 description: 'GI engine for later bounces (light_cache needed by auto exposure)', },
          gi_saturation: { plugin: GI, parameter: :saturation, type: :number, range: 0.0..2.0, group: :gi,
                           description: 'Color bleeding strength (lower = less colored bounce)', },
          gi_contrast: { plugin: GI, parameter: :contrast, type: :number, range: 0.0..2.0, group: :gi,
                         description: 'GI contrast', },
          ambient_occlusion: { plugin: GI, parameter: :ao_on, type: :boolean, group: :gi,
                               description: 'Ambient occlusion in corners and contacts', },
          ao_amount: { plugin: GI, parameter: :ao_amount, type: :number, range: 0.0..1.0, group: :gi,
                       description: 'Ambient occlusion amount', },
          ao_radius: { plugin: GI, parameter: :ao_radius, type: :length, range: 0.0..100.0, group: :gi,
                       description: 'Ambient occlusion radius in meters', },
          sun_enabled: { plugin: SUN, parameter: :enabled, type: :boolean, group: :sun,
                         description: 'Sun and sky light on/off (position follows SketchUp shadows: time of day)', },
          sun_intensity: { plugin: SUN, parameter: :intensity_multiplier, type: :number, range: 0.0..100.0,
                           group: :sun, description: 'Sun brightness multiplier', },
          sun_size: { plugin: SUN, parameter: :size_multiplier, type: :number, range: 0.0..100.0, group: :sun,
                      description: 'Sun disc size: bigger = softer shadows', },
          sky_turbidity: { plugin: SUN, parameter: :turbidity, type: :number, range: 2.0..20.0, group: :sun,
                           description: 'Haze: 2 very clear, 3 clear, 5+ hazy and warmer', },
          sky_ozone: { plugin: SUN, parameter: :ozone, type: :number, range: 0.0..1.0, group: :sun,
                       description: 'Ozone: higher = bluer light', },
          sun_filter_color: { plugin: SUN, parameter: :filter_color, type: :rgb, group: :sun,
                              description: 'Tint of the sun light, RGB 0-255', },
          ground_albedo: { plugin: SUN, parameter: :ground_albedo, type: :rgb, group: :sun,
                           description: 'Color of the ground the sky light bounces from, RGB 0-255', },
          environment_gi_override: { plugin: ENVIRONMENT, parameter: :override_gi, type: :boolean,
                                     group: :environment,
                                     description: 'Use environment_gi_color instead of the sky for ambient light', },
          environment_gi_color: { plugin: ENVIRONMENT, parameter: :gi_color, type: :rgb, group: :environment,
                                  description: 'Ambient light color when overridden, RGB 0-255', },
          environment_gi_multiplier: { plugin: ENVIRONMENT, parameter: :gi_tex_mult, type: :number,
                                       range: 0.0..100.0, group: :environment,
                                       description: 'Ambient (sky/GI environment) light multiplier', },
          background_sky: { plugin: ENVIRONMENT, parameter: :bg_tex_tex_on, type: :boolean, group: :environment,
                            description: 'Show the sky behind windows and openings; off = background_color ' \
                                         '(use off for night scenes)', },
          background_color: { plugin: ENVIRONMENT, parameter: :bg_color, type: :rgb, group: :environment,
                              description: 'Background color, RGB 0-255', },
          background_multiplier: { plugin: ENVIRONMENT, parameter: :bg_tex_mult, type: :number, range: 0.0..100.0,
                                   group: :environment, description: 'Background brightness multiplier', },
        }.freeze

      end
    end
  end
end
