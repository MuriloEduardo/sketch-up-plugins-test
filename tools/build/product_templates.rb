# frozen_string_literal: true

# Arquivos gerados para cada produto derivado.
module ProductTemplates

  # @return [String] Ruby single-quoted literal (the style the lint expects)
  def self.quote(text)
    "'#{text.gsub(/[\\']/) { |char| "\\#{char}" }}'"
  end

  def self.product(manifest)
    id = manifest['id']
    namespace = manifest['namespace']
    features = manifest['features']
    <<~RUBY
      # frozen_string_literal: true

      # Gerado por tools/build/product_builder.rb a partir de products/#{id}.json.
      module MuriloEduardo
        module #{namespace}
          module Product

            NAME = #{quote(manifest['name'])}

            FEATURES = %w[#{features.join(' ')}].freeze

          end
        end
      end
    RUBY
  end

  def self.registration(manifest)
    id = manifest['id']
    namespace = manifest['namespace']
    <<~RUBY
      # frozen_string_literal: true

      require 'sketchup'
      require 'extensions'

      # Gerado por tools/build/product_builder.rb a partir de products/#{id}.json.
      module MuriloEduardo
        module #{namespace}

          unless file_loaded?(__FILE__)
            EXTENSION = SketchupExtension.new(#{quote(manifest['name'])}, '#{id}/main')
            EXTENSION.description = #{quote(manifest['description'])}
            EXTENSION.version     = '#{manifest['version']}'
            EXTENSION.copyright   = 'Murilo Eduardo © 2026'
            EXTENSION.creator     = 'Murilo Eduardo'
            Sketchup.register_extension(EXTENSION, true)
            file_loaded(__FILE__)
          end

        end
      end
    RUBY
  end

end
