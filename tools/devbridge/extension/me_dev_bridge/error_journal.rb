# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'time'

module MuriloEduardoDev
  module DevBridge
    # Append-only error log on the SketchUp machine
    # (%APPDATA%/MuriloEduardoDev/errors/errors.jsonl): one JSON object per
    # line, never rewritten, so nothing the user saw is lost, even offline.
    # A cursor file remembers how many bytes were already delivered to the
    # platform (/api/laboratorio/erros); resending is harmless because every
    # entry carries its own id.
    #
    # Pure Ruby (unit tested).
    class ErrorJournal

      FILE = 'errors.jsonl'
      CURSOR = 'errors.cursor'
      MESSAGE_LIMIT = 8000
      FRAME_LIMIT = 100

      Batch = Struct.new(:items, :offset, keyword_init: true)

      # @return [String]
      attr_reader :dir

      # @param dir [String]
      # @param clock [#call] current Time (tests)
      # @param id [#call] new unique id (tests)
      def initialize(dir, clock: -> { Time.now }, id: -> { self.class.uuid })
        @dir = dir
        @clock = clock
        @id = id
      end

      # Random UUID v4 from Random.urandom: SecureRandom goes through OpenSSL,
      # which can freeze SketchUp on Windows.
      #
      # @return [String]
      def self.uuid
        bytes = Random.urandom(16).bytes
        bytes[6] = (bytes[6] & 0x0f) | 0x40
        bytes[8] = (bytes[8] & 0x3f) | 0x80
        hex = bytes.pack('C*').unpack1('H*')
        [hex[0, 8], hex[8, 4], hex[12, 4], hex[16, 4], hex[20, 12]].join('-')
      end

      # Appends one error.
      #
      # @param source [String] "console", "toolkit", "bridge" or "crash"
      # @param kind [String] exception class, or a label
      # @param message [String]
      # @param backtrace [Array<String>]
      # @param fields [Hash] machine:, sketchup_version:, model_name:, context:
      # @return [Hash] the stored entry
      def record(source:, kind:, message:, backtrace: [], **fields)
        entry = {
          id: @id.call,
          at: @clock.call.iso8601(3),
          source: source.to_s,
          kind: kind.to_s.empty? ? 'Error' : kind.to_s,
          message: clean(message.to_s, MESSAGE_LIMIT).then { |text| text.strip.empty? ? '(sem mensagem)' : text },
          backtrace: Array(backtrace).first(FRAME_LIMIT).map { |frame| clean(frame.to_s, 1000) },
        }.merge(fields.compact)
        FileUtils.mkdir_p(dir)
        File.open(path, 'a:UTF-8') { |file| file.write("#{JSON.generate(entry)}\n") }
        entry
      end

      # Entries not yet delivered, oldest first.
      #
      # @param limit [Integer]
      # @return [Batch] `offset` is the cursor to store once they are delivered
      def pending(limit = 100)
        offset = cursor
        items = []
        return Batch.new(items: items, offset: offset) unless File.exist?(path)

        File.open(path, 'rb') do |file|
          file.seek(offset)
          while items.size < limit && (line = file.gets)
            break unless line.end_with?("\n") # a line still being written

            offset += line.bytesize
            entry = parse(line)
            items << entry if entry
          end
        end
        Batch.new(items: items, offset: offset)
      end

      # @param offset [Integer] from {#pending}
      def mark_sent(offset)
        FileUtils.mkdir_p(dir)
        File.write(cursor_path, offset.to_s)
      end

      # @param limit [Integer]
      # @return [Array<Hash>] the newest entries, newest last
      def recent(limit = 20)
        return [] unless File.exist?(path)

        File.readlines(path, encoding: 'UTF-8').last(limit).filter_map { |line| parse(line) }
      end

      # @return [Integer] bytes delivered so far
      def cursor
        File.exist?(cursor_path) ? Integer(File.read(cursor_path).strip, exception: false).to_i : 0
      end

      def path = File.join(dir, FILE)

      private

      def cursor_path = File.join(dir, CURSOR)

      def parse(line)
        JSON.parse(line.force_encoding(Encoding::UTF_8).scrub)
      rescue JSON::ParserError
        nil
      end

      # The platform takes UTF-8. Windows error messages come in the ANSI code
      # page (Windows-1252 on pt-BR machines), tagged as such or as raw bytes.
      def clean(text, limit)
        utf8 = if [Encoding::UTF_8, Encoding::BINARY, Encoding::US_ASCII].include?(text.encoding)
                 text.dup.force_encoding(Encoding::UTF_8)
               else
                 text.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: '?')
               end
        unless utf8.valid_encoding?
          utf8 = text.dup.force_encoding(Encoding::WINDOWS_1252)
                     .encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: '?')
        end
        utf8[0, limit]
      end

    end
  end
end
