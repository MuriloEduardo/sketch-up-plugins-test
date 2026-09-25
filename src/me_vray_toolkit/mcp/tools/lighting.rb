# frozen_string_literal: true

Sketchup.require('me_vray_toolkit/core/actions')
Sketchup.require('me_vray_toolkit/mcp/tools/support')
Sketchup.require('me_vray_toolkit/vray/bridge')
Sketchup.require('me_vray_toolkit/vray/lighting_presets')
Sketchup.require('me_vray_toolkit/vray/render_parameters')

module MuriloEduardo
  module VRayToolkit
    module Mcp
      module Tools
        # How the light looks in the render: exposure, white balance, tone
        # mapping, GI, sun and sky, environment, time of day and presets for
        # common lighting situations.
        module Lighting

          extend Support

          Parameters = VRayBridge::RenderParameters
          Presets = VRayBridge::LightingPresets

          def self.current(group = nil)
            Parameters.from_vray(VRayBridge.read_render_parameters, group: group)
          end

          def self.time_of_day
            time = model.shadow_info['ShadowTime']
            { date: time.strftime('%Y-%m-%d'), time: time.strftime('%H:%M') }
          end

          # Model-local time (SketchUp keeps ShadowTime in the model's time zone).
          def self.set_time(hour:, minute: 0, month: nil, day: nil)
            info = model.shadow_info
            now = info['ShadowTime']
            offset = info['TZOffset'].to_f
            hours = offset.abs.floor
            zone = format('%{sign}%<hours>02d:%<minutes>02d', sign: offset.negative? ? '-' : '+', hours: hours,
                                                              minutes: ((offset.abs - hours) * 60).round)
            info['ShadowTime'] = Time.new(now.year, month || now.month, day || now.day, hour, minute, 0, zone)
          end

          Actions.register(
              name: 'get_render_parameters', group: :vray, read_only: true,
              description: 'How V-Ray turns light into the image: camera exposure (f-number, shutter, ISO, EV), ' \
                           'automatic exposure and white balance, tone mapping (highlight burn), GI and ambient ' \
                           'occlusion, sun and sky, environment light, and the time of day that places the sun.',
              schema: { group: { type: :enum, values: Parameters::GROUPS.map(&:to_s),
                                 description: 'Only this group (default: all)', } }
            ) do |params|
            require_vray
            current(params[:group]&.to_sym).merge(time_of_day: time_of_day)
          end

          Actions.register(
              name: 'set_render_parameters', group: :vray, idempotent: true,
              description: 'Changes any of the lighting-related V-Ray parameters (only those given; see ' \
                           'get_render_parameters). Tips: too dark/bright → change shutter_speed or use ' \
                           'auto_exposure; blown windows → lower highlight_burn; orange lamps → ' \
                           'white_balance_kelvin 3000-4000 or auto_white_balance. Kept when the model is saved.',
              schema: Parameters.params_schema
            ) do |params|
            require_vray
            values = params.compact
            raise ArgumentError, 'give at least one parameter' if values.empty?

            change('Set V-Ray Lighting') { VRayBridge.write_render_parameters(values) }
            current
          end

          Actions.register(
              name: 'set_time_of_day', group: :vray, idempotent: true,
              description: 'Moves the sun by setting the model\'s time (and optionally date), in the model\'s time ' \
                           'zone. V-Ray\'s sun follows it. One undo step.',
              schema: {
                hour: { type: :integer, required: true, range: 0..23 },
                minute: { type: :integer, default: 0, range: 0..59 },
                month: { type: :integer, range: 1..12 },
                day: { type: :integer, range: 1..31 },
              }
            ) do |params|
            change('Set Time of Day') { set_time(**params.slice(:hour, :minute, :month, :day).compact) }
            time_of_day
          end

          Actions.register(
              name: 'list_lighting_presets', group: :vray, read_only: true,
              description: 'Lighting starting points: exterior day, golden hour, overcast, interior by daylight, ' \
                           'interior by lamps, studio.'
            ) { { presets: Presets.list } }

          Actions.register(
              name: 'apply_lighting_preset', group: :vray, idempotent: true,
              description: 'Applies a lighting preset (camera exposure, white balance, tone mapping, GI, sun and ' \
                           'sky, and the time of day for daylight presets). Render a test afterwards and fine-tune ' \
                           'with set_render_parameters. One undo step.',
              schema: {
                name: { type: :enum, values: Presets::PRESETS.keys, required: true },
                keep_time: { type: :boolean, default: false, description: 'Do not change the time of day' },
              }
            ) do |params|
            require_vray
            preset = Presets.fetch(params[:name])
            change('Apply Lighting Preset') do
              VRayBridge.write_render_parameters(preset[:parameters])
              set_time(**preset[:time]) if preset[:time] && !params[:keep_time]
            end
            { preset: params[:name], parameters: current, time_of_day: time_of_day }
          end

        end
      end
    end
  end
end
