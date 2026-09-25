# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'securerandom'

module MuriloEduardoDev
  module DevBridge
    # Settings stored as JSON on the SketchUp machine
    # (%APPDATA%/MuriloEduardoDev/config.json). Pure Ruby (unit tested).
    #
    # The server only ever listens on the loopback interface. Remote access is
    # through an SSH tunnel to this machine (Windows OpenSSH Server), so the
    # bridge adds no network-reachable surface of its own.
    class Config

      BIND = '127.0.0.1'

      DEFAULTS = {
        'port' => 7860,
        # Off by default. The machine owner can turn it on or off from the
        # menu (Extensions › Dev Bridge › Start Automatically).
        'autostart' => false,
      }.freeze

      TOKEN_BYTES = 24

      # @return [String]
      attr_reader :path

      # @param path [String]
      def initialize(path)
        @path = path
        @data = load_or_create
      end

      def bind = BIND
      def port = Integer(@data.fetch('port'))
      def autostart? = @data.fetch('autostart') == true
      def token = @data.fetch('token')

      # Studio platform that receives the error audit
      # (e.g. https://lilianrosa.com.br); nil keeps errors only in the local journal.
      def lab_url = presence(@data['lab_url'])
      def lab_token = presence(@data['lab_token'])

      # @param url [String, nil]
      # @param token [String, nil]
      def set_lab(url:, token:)
        @data['lab_url'] = presence(url)&.chomp('/')
        @data['lab_token'] = presence(token)
        save
      end

      # @param value [Boolean] start the bridge when SketchUp loads it
      def autostart=(value)
        @data['autostart'] = value == true
        save
      end

      # @return [String] the new token
      def regenerate_token
        @data['token'] = SecureRandom.hex(TOKEN_BYTES)
        save
        token
      end

      private

      def presence(value)
        text = value.to_s.strip
        text.empty? ? nil : text
      end

      def load_or_create
        stored = File.exist?(path) ? JSON.parse(File.read(path)) : {}
        data = DEFAULTS.merge(stored)
        data['token'] = SecureRandom.hex(TOKEN_BYTES) if data['token'].to_s.empty?
        @data = data
        save if data != stored
        data
      end

      def save
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, JSON.pretty_generate(@data))
      end

    end
  end
end
