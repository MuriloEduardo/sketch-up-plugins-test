# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative 'product_templates'

# Monta um produto derivado a partir do produto completo em src/.
#
# src/me_vray_toolkit/ é a fonte única: pilares (core/, sketchup/, vray/) +
# todas as funcionalidades (features/<nome>/). Um produto derivado é descrito
# por products/<id>.json e recebe uma cópia dos pilares e só das features
# escolhidas, com o id e o namespace trocados. Cada produto fica isolado no
# próprio namespace (recomendação do Extension Warehouse: duplicar lógica
# compartilhada em vez de depender de uma extensão-biblioteca).
#
#   {
#     "id": "me_scene_audit",           // arquivo de registro e pasta
#     "namespace": "SceneAudit",        // MuriloEduardo::SceneAudit
#     "name": "Scene Audit",            // nome no Extension Manager e no menu
#     "version": "1.0.0",
#     "description": "…",
#     "features": ["scene_audit"]
#   }
class ProductBuilder

  SOURCE_ID = 'me_vray_toolkit'
  SOURCE_NAMESPACE = 'VRayToolkit'

  # Copiados para todo produto (pilares + carregador).
  SHARED = %w[main.rb core sketchup vray].freeze

  ID_PATTERN = /\Ame_[a-z0-9_]+\z/
  NAMESPACE_PATTERN = /\A[A-Z][A-Za-z0-9]*\z/
  VERSION_PATTERN = /\A\d+\.\d+\.\d+\z/
  REQUIRED_KEYS = %w[id namespace name version description features].freeze

  attr_reader :manifest

  # @param source_root [String] pasta com me_vray_toolkit.rb (normalmente src/)
  # @param manifest [Hash] conteúdo de products/<id>.json
  def initialize(source_root, manifest)
    @source_root = source_root
    @manifest = manifest
    validate!
  end

  # @param path [String] products/<id>.json
  # @return [ProductBuilder]
  def self.from_file(source_root, path)
    new(source_root, JSON.parse(File.read(path)))
  end

  def id = manifest['id']
  def namespace = manifest['namespace']
  def features = manifest['features']

  # Escreve <output_root>/<id>.rb e <output_root>/<id>/.
  #
  # @return [String] caminho do arquivo de registro gerado
  def build(output_root)
    target = File.join(output_root, id)
    FileUtils.rm_rf(target)
    source_files.each do |relative|
      destination = File.join(target, relative)
      FileUtils.mkdir_p(File.dirname(destination))
      File.write(destination, rewrite(File.read(File.join(source_dir, relative))))
    end
    File.write(File.join(target, 'product.rb'), ProductTemplates.product(manifest))
    registration = File.join(output_root, "#{id}.rb")
    File.write(registration, ProductTemplates.registration(manifest))
    registration
  end

  # @return [Array<String>] caminhos relativos a src/me_vray_toolkit/
  def source_files
    roots = SHARED + features.map { |feature| File.join('features', feature) }
    files = roots.flat_map do |root|
      path = File.join(source_dir, root)
      File.directory?(path) ? Dir.glob('**/*', base: path).map { |file| File.join(root, file) } : [root]
    end
    files.select { |relative| File.file?(File.join(source_dir, relative)) }.sort
  end

  # Features citadas por um arquivo (require de outra pasta ou constante).
  #
  # @return [Array<String>] nomes de features, sem repetição
  def self.feature_references(content)
    by_path = content.scan(%r{features/([a-z0-9_]+)/}).flatten
    by_constant = content.scan(/Features::([A-Z][A-Za-z0-9]*)/).flatten.map { |name| underscore(name) }
    (by_path + by_constant).uniq
  end

  def self.underscore(camel)
    camel.gsub(/([a-z0-9])([A-Z])/, '\1_\2').downcase
  end

  private

  def source_dir = File.join(@source_root, SOURCE_ID)

  def rewrite(content)
    content.gsub(SOURCE_ID, id).gsub(/\b#{SOURCE_NAMESPACE}\b/, namespace)
  end

  def validate!
    missing = REQUIRED_KEYS.reject { |key| manifest.key?(key) }
    raise ArgumentError, "manifest sem #{missing.join(', ')}" unless missing.empty?
    raise ArgumentError, "id inválido: #{id.inspect} (use me_<nome>)" unless id.match?(ID_PATTERN)
    raise ArgumentError, "id reservado: #{id}" if id == SOURCE_ID
    raise ArgumentError, "namespace inválido: #{namespace.inspect}" unless namespace.match?(NAMESPACE_PATTERN)
    unless manifest['version'].match?(VERSION_PATTERN)
      raise ArgumentError,
            "versão inválida: #{manifest['version'].inspect}"
    end
    raise ArgumentError, 'features vazia' if features.empty?

    features.each do |feature|
      raise ArgumentError, "feature inexistente: #{feature}" unless File.directory?(File.join(source_dir, 'features',
                                                                                              feature))
    end
    validate_isolation!
  end

  # Uma feature só pode depender dos pilares, nunca de outra feature: é o que
  # permite montar qualquer combinação delas.
  def validate_isolation!
    features.each do |feature|
      Dir.glob(File.join(source_dir, 'features', feature, '**', '*.rb')).each do |file|
        others = self.class.feature_references(File.read(file)) - [feature]
        raise ArgumentError, "#{file} depende de outra feature: #{others.join(', ')}" unless others.empty?
      end
    end
  end

end
