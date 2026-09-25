# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # Minimal HTTP/1.1 request parsing and response building (SketchUp's
      # Ruby 3.x has no WEBrick).
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module Http

        class BadRequest < StandardError; end
        class PayloadTooLarge < StandardError; end

        Request = Struct.new(:http_method, :path, :headers, :body, keyword_init: true)

        HEADER_END = "\r\n\r\n"
        MAX_HEADER_BYTES = 16_384

        STATUS_TEXT = {
          200 => 'OK', 202 => 'Accepted', 400 => 'Bad Request', 401 => 'Unauthorized', 403 => 'Forbidden',
          404 => 'Not Found', 405 => 'Method Not Allowed', 413 => 'Payload Too Large',
          500 => 'Internal Server Error',
        }.freeze

        class << self

          # Whether the buffer holds a full request (headers + declared body).
          #
          # @param buffer [String] raw bytes received so far
          # @param max_body [Integer]
          # @return [Boolean]
          # @raise [BadRequest, PayloadTooLarge]
          def complete?(buffer, max_body:)
            header_end = buffer.index(HEADER_END)
            if header_end.nil?
              raise BadRequest, 'headers too large' if buffer.bytesize > MAX_HEADER_BYTES

              return false
            end

            buffer.bytesize >= header_end + HEADER_END.bytesize + content_length(buffer[0...header_end], max_body)
          end

          # @param buffer [String] a complete request (see {.complete?})
          # @param max_body [Integer]
          # @return [Request]
          # @raise [BadRequest, PayloadTooLarge]
          def parse(buffer, max_body:)
            header_end = buffer.index(HEADER_END) or raise BadRequest, 'incomplete headers'
            head = buffer[0...header_end]
            lines = head.split("\r\n")
            method, target, version = lines.shift.to_s.split(' ', 3)
            raise BadRequest, 'malformed request line' unless method && target && version&.start_with?('HTTP/')

            length = content_length(head, max_body)
            body = buffer.byteslice(header_end + HEADER_END.bytesize, length).to_s
            raise BadRequest, 'truncated body' if body.bytesize < length

            Request.new(http_method: method.upcase, path: target.split('?', 2).first, headers: headers(lines),
                        body: body.force_encoding(Encoding::UTF_8))
          end

          # @param status [Integer]
          # @param body [String]
          # @param headers [Hash{String => String}]
          # @return [String] raw HTTP response
          def response(status, body: '', headers: {})
            lines = ["HTTP/1.1 #{status} #{STATUS_TEXT.fetch(status, 'Unknown')}"]
            headers.each { |name, value| lines << "#{name}: #{value}" }
            lines << "Content-Length: #{body.bytesize}" << 'Connection: close' << '' << body
            lines.join("\r\n")
          end

          private

          def headers(lines)
            lines.each_with_object({}) do |line, result|
              name, value = line.split(':', 2)
              raise BadRequest, "malformed header: #{line}" if value.nil?

              result[name.strip.downcase] = value.strip
            end
          end

          def content_length(head, max_body)
            match = head.match(/^content-length:\s*(\S+)\s*$/i)
            return 0 if match.nil?
            raise BadRequest, 'invalid content-length' unless match[1].match?(/\A\d+\z/)

            length = match[1].to_i
            raise PayloadTooLarge, "body exceeds #{max_body} bytes" if length > max_body

            length
          end

        end

      end
    end
  end
end
