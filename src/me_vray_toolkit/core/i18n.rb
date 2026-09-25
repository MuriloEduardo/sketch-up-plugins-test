# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # Minimal translation lookup. Each feature keeps its own string table:
    #
    #   STRINGS = {
    #     'en' => { title: 'Scene Audit', found: '%{count} found' },
    #     'pt-BR' => { title: 'Auditoria de Cena', found: '%{count} encontrados' },
    #   }.freeze
    #
    # Lookup order: exact locale ("pt-BR"), then language ("pt" matches the
    # first "pt-*" table), then English, then the key itself.
    #
    # Pure Ruby: unit tested in the Docker toolchain. The locale is set by
    # main.rb from `Sketchup.get_locale`.
    module I18n

      DEFAULT_LOCALE = 'en'

      class << self

        # @return [String]
        def locale
          @locale || DEFAULT_LOCALE
        end

        # @param value [String, nil] e.g. "pt-BR", "en-US"
        def locale=(value)
          @locale = value.to_s.empty? ? nil : value.to_s
        end

        # @param table [Hash{String => Hash{Symbol => String}}]
        # @param key [Symbol]
        # @param values [Hash{Symbol => Object}] replaces %{name} placeholders
        # @return [String]
        def t(table, key, **values)
          text = candidate_tables(table).lazy.filter_map { |strings| strings[key] }.first || key.to_s
          text.gsub(/%\{(\w+)\}/) { values.fetch(Regexp.last_match(1).to_sym, Regexp.last_match(0)).to_s }
        end

        private

        def candidate_tables(table)
          language = locale.split('-').first
          same_language = table.find { |name, _strings| name.split('-').first == language }&.last
          [table[locale], same_language, table[DEFAULT_LOCALE]].compact
        end

      end

    end
  end
end
