# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Finds errors in the text SketchUp writes to its Ruby Console (from any
    # extension, V-Ray included) and hands each one, with its backtrace, to a
    # block. Text arrives in arbitrary chunks; an error is complete when a line
    # that is not part of its backtrace arrives, or on {#flush}.
    #
    # Recognized headers:
    #   Error: #<NoMethodError: undefined method `x' for nil:NilClass>   (SketchUp)
    #   C:/a.rb:3:in `m': undefined method `x' (NoMethodError)            (Ruby)
    #   Error: something failed / ERROR something failed                  (plain)
    #   [V-Ray] Error: ... / V-Ray: ... failed                            (V-Ray)
    #
    # Pure Ruby (unit tested).
    class ConsoleParser

      TAIL_LINES = 40
      FRAME_LIMIT = 100

      SKETCHUP = /\A(?:Error:\s*)?#<([A-Z][\w:]*):\s*(.*?)>?\s*\z/m
      RUBY = /\A(.+?:\d+:in\s+.+?):\s+(.*)\s+\(([A-Z][\w:]*)\)\s*\z/
      PLAIN = /\A(?:Error|ERROR|Exception)\b[:\s-]\s*(.+)\z/
      VRAY = /\A\s*\[?V-?Ray[^\]:]*\]?:?\s*(.*\b(?:error|failed|failure|exception)\b.*)\z/i
      FRAME = /\A\s*(?:from\s+)?(?:<internal:[^>]+>|(?:[A-Za-z]:)?[^\s:][^:]*):\d+(?::in\b.*)?\s*\z/
      EXCEPTION_CLASS = /(?:Error|Exception|Interrupt|Exit|Timeout)\z/

      # @return [Array<String>] the last lines seen, for context
      attr_reader :tail

      # @yieldparam error [Hash] kind:, message:, backtrace:
      def initialize(&on_error)
        @on_error = on_error
        @partial = +''
        @current = nil
        @tail = []
      end

      # @param text [String]
      def feed(text)
        @partial << text.to_s.dup.force_encoding(Encoding::UTF_8).scrub('?')
        while (index = @partial.index("\n"))
          line = @partial.slice!(0..index).chomp.delete_suffix("\r")
          take(line)
        end
      end

      # Emits the error being collected, and a pending partial line.
      def flush
        take(@partial.slice!(0..)) unless @partial.empty?
        emit
      end

      private

      def take(line)
        remember(line)
        return if line.strip.empty? && @current.nil?

        if @current && FRAME.match?(line) && !header(line)
          @current[:backtrace] << line.strip.sub(/\Afrom\s+/, '') if @current[:backtrace].size < FRAME_LIMIT
          return
        end

        emit
        @current = header(line)
      end

      def header(line)
        text = line.strip
        if (match = SKETCHUP.match(text)) && EXCEPTION_CLASS.match?(match[1])
          { kind: match[1], message: match[2].strip, backtrace: [] }
        elsif (match = RUBY.match(text))
          { kind: match[3], message: match[2].strip, backtrace: [match[1]] }
        elsif (match = PLAIN.match(text))
          { kind: 'Error', message: match[1].strip, backtrace: [] }
        elsif (match = VRAY.match(text))
          { kind: 'V-Ray', message: match[1].strip, backtrace: [] }
        end
      end

      def emit
        error = @current
        @current = nil
        @on_error&.call(error.merge(tail: @tail.dup)) if error
      end

      def remember(line)
        @tail << line
        @tail.shift while @tail.size > TAIL_LINES
      end

    end
  end
end
