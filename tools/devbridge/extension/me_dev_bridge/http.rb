# frozen_string_literal: true

require 'json'
require 'uri'

module MuriloEduardoDev
  module DevBridge
    # Minimal HTTP/1.1 request parsing and response building (no WEBrick in
    # SketchUp's Ruby 3.x). Pure Ruby (unit tested in Docker).
    module Http

      class BadRequest < StandardError; end
      class PayloadTooLarge < StandardError; end

      Request = Struct.new(:http_method, :path, :query, :headers, :body, keyword_init: true)

      HEADER_END = "\r\n\r\n"
      MAX_HEADER_BYTES = 16_384

      STATUS_TEXT = {
        200 => 'OK',
        400 => 'Bad Request',
        401 => 'Unauthorized',
        403 => 'Forbidden',
        404 => 'Not Found',
        413 => 'Payload Too Large',
        500 => 'Internal Server Error',
      }.freeze

      # Whether the buffer holds a full request (headers + declared body).
      #
      # @param buffer [String] raw bytes received so far
      # @param max_body [Integer]
      # @return [Boolean]
      # @raise [BadRequest, PayloadTooLarge]
      def self.complete?(buffer, max_body:)
        header_end = buffer.index(HEADER_END)
        if header_end.nil?
          raise BadRequest, 'headers too large' if buffer.bytesize > MAX_HEADER_BYTES

          return false
        end

        length = content_length(buffer[0...header_end], max_body)
        buffer.bytesize >= header_end + HEADER_END.bytesize + length
      end

      # @param buffer [String] a complete request (see {.complete?})
      # @param max_body [Integer]
      # @return [Request]
      def self.parse(buffer, max_body:)
        header_end = buffer.index(HEADER_END)
        raise BadRequest, 'incomplete headers' if header_end.nil?

        head = buffer[0...header_end]
        lines = head.split("\r\n")
        method, target, version = lines.shift.to_s.split(' ', 3)
        raise BadRequest, 'malformed request line' unless method && target && version&.start_with?('HTTP/')

        headers = lines.each_with_object({}) do |line, result|
          name, value = line.split(':', 2)
          raise BadRequest, "malformed header: #{line}" if value.nil?

          result[name.strip.downcase] = value.strip
        end
        length = content_length(head, max_body)
        body_start = header_end + HEADER_END.bytesize
        body = buffer.byteslice(body_start, length).to_s
        raise BadRequest, 'truncated body' if body.bytesize < length

        path, query = target.split('?', 2)
        Request.new(http_method: method.upcase, path: path, query: parse_query(query), headers: headers, body: body)
      end

      # @param status [Integer]
      # @param payload [Hash]
      # @return [String] raw HTTP response
      def self.response(status, payload)
        body = JSON.generate(payload)
        [
          "HTTP/1.1 #{status} #{STATUS_TEXT.fetch(status, 'Unknown')}",
          'Content-Type: application/json; charset=utf-8',
          "Content-Length: #{body.bytesize}",
          'Connection: close',
          '',
          body,
        ].join("\r\n")
      end

      def self.content_length(head, max_body)
        match = head.match(/^content-length:\s*(\S+)\s*$/i)
        return 0 if match.nil?
        raise BadRequest, 'invalid content-length' unless match[1].match?(/\A\d+\z/)

        length = match[1].to_i
        raise PayloadTooLarge, "body exceeds #{max_body} bytes" if length > max_body

        length
      end
      private_class_method :content_length

      def self.parse_query(query)
        return {} if query.nil? || query.empty?

        query.split('&').to_h do |pair|
          key, value = pair.split('=', 2)
          [URI.decode_www_form_component(key.to_s), URI.decode_www_form_component(value.to_s)]
        end
      end
      private_class_method :parse_query

    end
  end
end
