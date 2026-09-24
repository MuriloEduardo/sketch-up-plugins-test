# frozen_string_literal: true

# Empacota cada extensão de src/ em dist/<nome>-<versao>.rbz.
# Uso: docker compose run --rm package   (ou `make package`)
#
# Estrutura exigida pelo Extension Warehouse: o .rbz (um .zip) contém
# exatamente dois itens na raiz — o arquivo de registro <nome>.rb e a pasta de
# suporte <nome>/. A versão é lida de `EXTENSION.version = '...'` no arquivo
# de registro (fonte única da versão).

require 'fileutils'
require 'zip'

ROOT = File.expand_path('../..', __dir__)
SOURCE = File.join(ROOT, 'src')
DIST = File.join(ROOT, 'dist')
VERSION_PATTERN = /EXTENSION\.version\s*=\s*['"]([^'"]+)['"]/

# Arquivos que nunca devem ir para o pacote.
EXCLUDED = [/\.DS_Store\z/, /Thumbs\.db\z/i, /~\z/, /\.swp\z/].freeze

def extension_version(registration_file)
  match = File.read(registration_file).match(VERSION_PATTERN)
  abort("Versão não encontrada em #{registration_file} (esperado EXTENSION.version = '...')") unless match
  match[1]
end

def package(registration_file)
  name = File.basename(registration_file, '.rb')
  support_folder = File.join(SOURCE, name)
  abort("Pasta de suporte ausente: src/#{name}/") unless File.directory?(support_folder)

  version = extension_version(registration_file)
  FileUtils.mkdir_p(DIST)
  output = File.join(DIST, "#{name}-#{version}.rbz")
  FileUtils.rm_f(output)

  files = Dir.glob(File.join(support_folder, '**', '*'), File::FNM_DOTMATCH)
             .select { |path| File.file?(path) }
             .reject { |path| EXCLUDED.any? { |pattern| path =~ pattern } }

  Zip::File.open(output, create: true) do |zip|
    zip.add("#{name}.rb", registration_file)
    files.sort.each do |path|
      zip.add(path.delete_prefix("#{SOURCE}/"), path)
    end
  end
  puts "#{output.delete_prefix("#{ROOT}/")} (#{files.size + 1} arquivos)"
end

registration_files = Dir.glob(File.join(SOURCE, '*.rb'))
abort('Nenhum arquivo de registro em src/*.rb') if registration_files.empty?
registration_files.each { |file| package(file) }
