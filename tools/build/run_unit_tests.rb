# frozen_string_literal: true

# Roda todos os testes em tests/unit/ (Minitest puro, fora do SketchUp).
# Uso: docker compose run --rm test   (ou `make test`)
#
# Só código que NÃO depende da API do SketchUp/V-Ray é testável aqui. Código
# que usa Sketchup::/UI::/VRay:: é testado com TestUp dentro do SketchUp
# (tests/sketchup/, `make su-testup`).

$LOAD_PATH.unshift(File.expand_path('../../tests/unit', __dir__))
Dir.glob(File.expand_path('../../tests/unit/**/*_test.rb', __dir__)).each { |file| require file }
