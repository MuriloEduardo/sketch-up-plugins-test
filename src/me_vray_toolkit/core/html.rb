# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Builds the static HTML shown in {ReportDialog}s. Everything that comes
    # from the model (names, paths) must go through {.escape}.
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    module Html

      ESCAPES = { '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;', "'" => '&#39;' }.freeze

      # Follows the system light/dark theme (HtmlDialog uses Chromium).
      STYLE = <<~CSS
        :root { --bg: #ffffff; --fg: #1f2328; --muted: #656d76; --line: #d0d7de;
                --error: #cf222e; --warning: #9a6700; --info: #0969da; }
        @media (prefers-color-scheme: dark) {
          :root { --bg: #1e1f22; --fg: #e6edf3; --muted: #9198a1; --line: #3d444d;
                  --error: #ff7b72; --warning: #d29922; --info: #58a6ff; }
        }
        body { background: var(--bg); color: var(--fg); margin: 16px;
               font: 13px/1.45 -apple-system, "Segoe UI", sans-serif; }
        h1 { font-size: 18px; margin: 0 0 12px; }
        h2 { font-size: 14px; margin: 20px 0 8px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { text-align: left; padding: 4px 8px; border-bottom: 1px solid var(--line);
                 vertical-align: top; overflow-wrap: anywhere; }
        th { color: var(--muted); font-weight: 600; }
        .muted { color: var(--muted); }
        .error { color: var(--error); font-weight: 600; }
        .warning { color: var(--warning); font-weight: 600; }
        .info { color: var(--info); }
      CSS

      class << self

        # @param text [Object]
        # @return [String]
        def escape(text)
          text.to_s.gsub(/[&<>"']/, ESCAPES)
        end

        # @param headers [Array<String>] plain text
        # @param rows [Array<Array<String>>] cells are already-safe HTML
        #   (escape model data with {.escape} first)
        # @return [String]
        def table(headers, rows)
          head = headers.map { |header| "<th>#{escape(header)}</th>" }.join
          body = rows.map { |cells| "<tr>#{cells.map { |cell| "<td>#{cell}</td>" }.join}</tr>" }.join("\n")
          "<table>\n<thead><tr>#{head}</tr></thead>\n<tbody>\n#{body}\n</tbody>\n</table>"
        end

        # @param title [String] plain text
        # @param body [String] safe HTML
        # @param lang [String]
        # @return [String] a complete HTML document
        def document(title:, body:, lang: 'en')
          <<~HTML
            <!DOCTYPE html>
            <html lang="#{escape(lang)}">
            <head>
            <meta charset="utf-8">
            <title>#{escape(title)}</title>
            <style>
            #{STYLE}</style>
            </head>
            <body>
            <h1>#{escape(title)}</h1>
            #{body}
            </body>
            </html>
          HTML
        end

      end

    end
  end
end
