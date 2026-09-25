# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module SceneAudit

        # One problem found in the model. `params` fill the placeholders of
        # the translated detail text (see STRINGS, key = `code`).
        Finding = Struct.new(:severity, :code, :subject, :params, keyword_init: true)

        # Turns plain facts about a model into findings and a summary.
        #
        # Pure Ruby: unit tested in the Docker toolchain. The data comes from
        # {ModelData} and {VRayBridge} (see feature.rb).
        class Analyzer

          SEVERITIES = %i[error warning info].freeze

          # Textures larger than this on either side are reported.
          HEAVY_TEXTURE_PIXELS = 4096

          # @return [Hash] from `VRayBridge.status`
          attr_reader :environment

          # @param environment [Hash] `VRayBridge.status`
          # @param materials [Array<Hash>] `ModelData.materials`
          # @param file_references [Array<Hash>] `VRayBridge.file_references`
          #   with `exists:` added
          # @param plugin_counts [Hash{Symbol => Integer}] `VRayBridge.plugin_counts`
          # @param heavy_texture_pixels [Integer]
          def initialize(environment:, materials:, file_references: [], plugin_counts: {},
              heavy_texture_pixels: HEAVY_TEXTURE_PIXELS)
            @environment = environment
            @materials = materials
            @file_references = file_references
            @plugin_counts = plugin_counts
            @heavy_texture_pixels = heavy_texture_pixels
          end

          # @return [Array<Finding>] errors first, then warnings, then info
          def findings
            found = vray_findings + missing_file_findings + heavy_texture_findings + unused_material_findings
            found.sort_by { |finding| [SEVERITIES.index(finding.severity), finding.code.to_s, finding.subject.to_s] }
          end

          # @return [Hash{Symbol => Integer}]
          def summary
            {
              materials: @materials.size,
              textured_materials: @materials.count { |material| material[:texture_file] },
              unused_materials: unused_materials.size,
              vray_materials: @plugin_counts.fetch(:material, 0),
              vray_lights: @plugin_counts.fetch(:light, 0),
              file_references: @file_references.map { |reference| reference[:path] }.uniq.size,
              missing_files: missing_paths.size,
            }
          end

          private

          def vray_findings
            return [] if @environment[:vray_api_available]

            [Finding.new(severity: :warning, code: :vray_unavailable, subject: 'V-Ray', params: {})]
          end

          def missing_paths
            @file_references.reject { |reference| reference[:exists] }.group_by { |reference| reference[:path] }
          end

          def missing_file_findings
            missing_paths.map do |path, references|
              plugins = references.map { |reference| reference[:plugin] }.uniq.sort.join(', ')
              Finding.new(severity: :error, code: :missing_file, subject: path, params: { plugins: plugins })
            end
          end

          def heavy_texture_findings
            @materials.filter_map do |material|
              width = material[:texture_width].to_i
              height = material[:texture_height].to_i
              next if [width, height].max <= @heavy_texture_pixels

              Finding.new(severity: :warning, code: :heavy_texture, subject: material[:display_name],
                          params: { width: width, height: height, limit: @heavy_texture_pixels })
            end
          end

          def unused_materials
            @materials.select { |material| material[:uses].to_i.zero? }
          end

          def unused_material_findings
            unused_materials.map do |material|
              Finding.new(severity: :info, code: :unused_material, subject: material[:display_name], params: {})
            end
          end

        end

      end
    end
  end
end
