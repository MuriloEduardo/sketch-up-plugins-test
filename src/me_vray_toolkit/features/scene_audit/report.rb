# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module SceneAudit

        # Renders an {Analyzer} result as an HTML document in the current locale.
        #
        # Pure Ruby (needs {I18n}, {Html} and STRINGS loaded): unit tested in
        # the Docker toolchain.
        module Report

          # @param analyzer [Analyzer]
          # @return [String]
          def self.render(analyzer)
            body = [
              "<h2>#{Html.escape(t(:summary))}</h2>",
              summary_table(analyzer),
              "<h2>#{Html.escape(t(:findings))}</h2>",
              findings_table(analyzer.findings),
            ].join("\n")
            Html.document(title: t(:title), body: body, lang: I18n.locale)
          end

          def self.summary_table(analyzer)
            environment = analyzer.environment
            summary = analyzer.summary
            vray = environment[:vray_version] || t(:vray_not_loaded)
            vray = "#{vray} (API #{environment[:vray_api_version]})" if environment[:vray_api_version]
            materials = "#{summary[:materials]} (#{summary[:textured_materials]} / #{summary[:unused_materials]})"
            rows = [
              [t(:sketchup_version), environment[:sketchup_version]],
              [t(:vray_version), vray],
              [t(:materials), materials],
              [t(:vray_materials), summary[:vray_materials]],
              [t(:vray_lights), summary[:vray_lights]],
              [t(:file_references), "#{summary[:file_references]} (#{summary[:missing_files]})"],
            ]
            Html.table([t(:col_item), t(:col_value)], rows.map { |cells| cells.map { |cell| Html.escape(cell) } })
          end
          private_class_method :summary_table

          def self.findings_table(findings)
            return "<p class=\"muted\">#{Html.escape(t(:no_findings))}</p>" if findings.empty?

            rows = findings.map do |finding|
              [
                "<span class=\"#{finding.severity}\">#{Html.escape(t(:"severity_#{finding.severity}"))}</span>",
                Html.escape(finding.subject),
                Html.escape(t(finding.code, **finding.params)),
              ]
            end
            Html.table([t(:col_severity), t(:col_item), t(:col_detail)], rows)
          end
          private_class_method :findings_table

          def self.t(key, **values)
            I18n.t(STRINGS, key, **values)
          end
          private_class_method :t

        end

      end
    end
  end
end
