# frozen_string_literal: true

require 'json'
require 'time'

module MuriloEduardoDev
  module DevBridge
    # Delivers the {ErrorJournal} to the studio platform
    # (POST <lab_url>/api/laboratorio/erros, Bearer <lab_token>), one batch at
    # a time. The cursor only moves on a 2xx, so a failed delivery is retried
    # on the next tick; the platform ignores ids it already has.
    #
    # Pure Ruby (unit tested): the HTTP call is injected. In SketchUp it is
    # an asynchronous Sketchup::Http::Request.
    class ErrorUploader

      PATH = '/api/laboratorio/erros'
      BATCH = 100

      # @return [Hash, nil] outcome of the last attempt
      attr_reader :last

      # @param journal [ErrorJournal]
      # @param config [#lab_url, #lab_token]
      # @param post [#call] (url, headers, body) { |status, body| } — calls the
      #   block when the response arrives (now or later)
      # @param clock [#call]
      def initialize(journal:, config:, post:, clock: -> { Time.now })
        @journal = journal
        @config = config
        @post = post
        @clock = clock
        @in_flight = false
      end

      # The `post` used inside SketchUp: asynchronous, answered on the main
      # thread.
      def self.sketchup_post(url, headers, body, &on_response)
        request = Sketchup::Http::Request.new(url, Sketchup::Http::POST)
        request.headers = headers
        request.body = body
        @requests = [request] # keep a reference until the callback runs
        request.start { |_request, response| on_response.call(response.status_code, response.body) }
      end

      # @return [Integer, nil] how many errors were sent, nil when none
      def tick
        return if @in_flight || !@config.lab_url || !@config.lab_token

        batch = @journal.pending(BATCH)
        return if batch.items.empty?

        send_batch(batch)
        batch.items.size
      end

      private

      def send_batch(batch)
        @in_flight = true
        headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{@config.lab_token}" }
        @post.call("#{@config.lab_url.chomp('/')}#{PATH}", headers,
                   JSON.generate(errors: batch.items)) do |status, body|
          delivered(batch, status, body)
        end
      rescue StandardError => error
        @in_flight = false
        @last = { at: @clock.call.iso8601, error: "#{error.class}: #{error.message}" }
      end

      def delivered(batch, status, body)
        ok = status.to_i.between?(200, 299)
        @journal.mark_sent(batch.offset) if ok
        @last = { at: @clock.call.iso8601, status: status.to_i, sent: batch.items.size,
                  body: ok ? nil : body.to_s[0, 300], }
      ensure
        @in_flight = false
      end

    end
  end
end
