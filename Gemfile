# frozen_string_literal: true

source 'https://rubygems.org'

# Todas as gems rodam dentro do container (docker/Dockerfile). Nada aqui é
# carregado pelo SketchUp — extensões não podem instalar gems em runtime.

group :development do
  gem 'minitest', '~> 5.25'         # Testes unitários de lógica pura (fora do SketchUp).
  gem 'sketchup-api-stubs'          # Stubs + YARD da API Ruby do SketchUp (insight e índice da API).
  gem 'solargraph'                  # Language server com suporte aos stubs.
end

group :documentation do
  gem 'commonmarker', '~> 0.23'     # YARD com Markdown.
  gem 'yard', '~> 0.9'
end

group :analysis do
  gem 'rubocop', '>= 1.85', '< 2.0'
  gem 'rubocop-sketchup', '~> 2.1.1' # Regras do Extension Warehouse.
end

group :packaging do
  gem 'rubyzip', '~> 2.3' # Empacotamento .rbz.
end
