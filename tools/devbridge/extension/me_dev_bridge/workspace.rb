# frozen_string_literal: true

require 'fileutils'

module MuriloEduardoDev
  module DevBridge
    # Local copy of the repository's src/ and tests/ on the SketchUp machine,
    # kept in sync from the development machine (`make su-sync`). Loads the
    # extensions under development from there. Pure Ruby (unit tested).
    class Workspace

      ROOTS = %w[src tests].freeze

      # @return [String]
      attr_reader :root

      # @param root [String] normalized with File.expand_path, which on Windows
      #   turns backslashes into "/" (Dir.glob treats "\\" as an escape).
      def initialize(root)
        @root = File.expand_path(root)
      end

      def source_dir = File.join(root, 'src')

      # Mirrors the given files into the workspace.
      #
      # @param files [Hash{String => String}] "src/..." or "tests/..." => bytes
      # @param prune [Boolean] delete workspace files not present in `files`
      # @return [Hash{Symbol => Integer}]
      # @raise [ArgumentError] on unsafe paths (nothing is written)
      def sync(files, prune: true)
        unsafe = files.keys.reject { |path| Security.safe_relative_path?(path, ROOTS) }
        raise ArgumentError, "unsafe paths: #{unsafe.first(5).join(', ')}" unless unsafe.empty?

        written = 0
        files.each do |relative, content|
          target = File.join(root, relative)
          next if File.file?(target) && File.binread(target) == content

          FileUtils.mkdir_p(File.dirname(target))
          File.binwrite(target, content)
          written += 1
        end
        deleted = prune ? prune_missing(files.keys) : 0
        { files: files.size, written: written, unchanged: files.size - written, deleted: deleted }
      end

      # Adds src/ to the load path and registers the extensions found there.
      # Development-only: published extensions must not touch $LOAD_PATH.
      #
      # @return [Array<String>] registration files required for the first time
      def activate
        $LOAD_PATH << source_dir unless $LOAD_PATH.include?(source_dir)
        Dir.glob(File.join(source_dir, '*.rb')).select { |file| require(file) }
      end

      # Registers new extensions and reloads implementation files.
      #
      # @return [Hash{Symbol => Object}]
      def reload
        registered = activate
        files = Dir.glob(File.join(source_dir, '*', '**', '*.rb'))
        silence_warnings { files.each { |file| load(file) } }
        { registered: registered.map { |file| File.basename(file) }, reloaded: files.size }
      end

      private

      def prune_missing(keep)
        keep_set = keep.to_h { |relative| [File.join(root, relative), true] }
        existing = ROOTS.flat_map { |folder| Dir.glob(File.join(root, folder, '**', '*'), File::FNM_DOTMATCH) }
        stale = existing.select { |path| File.file?(path) && !keep_set.key?(path) }
        stale.each { |path| File.delete(path) }
        remove_empty_directories
        stale.size
      end

      def remove_empty_directories
        ROOTS.each do |folder|
          Dir.glob(File.join(root, folder, '**', '*')).select { |path| File.directory?(path) }
             .sort_by { |path| -path.length }
             .each { |path| Dir.rmdir(path) if Dir.empty?(path) }
        end
      end

      def silence_warnings
        original = $VERBOSE
        $VERBOSE = nil
        yield
      ensure
        $VERBOSE = original
      end

    end
  end
end
