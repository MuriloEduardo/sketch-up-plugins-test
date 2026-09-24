# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Authentication and path validation. Pure Ruby (unit tested in Docker).
    module Security

      # Constant-time comparison, so response timing does not leak the token.
      #
      # @param expected [String]
      # @param given [String, nil]
      # @return [Boolean]
      def self.token_matches?(expected, given)
        return false if expected.to_s.empty? || given.nil?

        expected_bytes = expected.to_s.b
        given_bytes = given.to_s.b
        return false unless expected_bytes.bytesize == given_bytes.bytesize

        difference = 0
        expected_bytes.each_byte.with_index { |byte, index| difference |= byte ^ given_bytes.getbyte(index) }
        difference.zero?
      end

      LOOPBACK_ADDRESSES = ['127.0.0.1', '::1', '::ffff:127.0.0.1'].freeze

      # Only local connections are served; remote clients arrive through the
      # SSH tunnel, which connects from the loopback interface.
      #
      # @param address [String] client IP address
      # @return [Boolean]
      def self.loopback?(address)
        LOOPBACK_ADDRESSES.include?(address)
      end

      # Accepts only "root/relative/path" with forward slashes, inside one of
      # the allowed roots, with no traversal, absolute or drive paths.
      #
      # @param path [String]
      # @param roots [Array<String>]
      # @return [Boolean]
      def self.safe_relative_path?(path, roots)
        text = path.to_s
        return false if text.empty? || text.include?("\0") || text.include?('\\')
        return false if text.start_with?('/') || text.match?(/\A[A-Za-z]:/)

        parts = text.split('/', -1)
        return false if parts.size < 2
        return false if parts.any? { |part| part.empty? || part == '.' || part == '..' }

        roots.include?(parts.first)
      end

    end
  end
end
