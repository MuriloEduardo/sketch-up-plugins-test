# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # In-process publish/subscribe bus: what happens (an action ran, the
    # model changed, a render progressed) is published once and every
    # interested part listens (agent window, MCP notifications, cloud relay,
    # logs). Publishers never know their subscribers.
    #
    #   Events.subscribe('action.') { |event| log(event) }   # prefix match
    #   Events.publish('action.completed', name: 'list_scenes', ms: 3)
    #
    # A failing subscriber is isolated: the error is kept in {.last_error}
    # and the other subscribers still run. The latest events are kept in a
    # small ring buffer ({.recent}).
    #
    # Pure Ruby: unit tested in the Docker toolchain.
    module Events

      Event = Struct.new(:topic, :payload, :at, keyword_init: true)

      RECENT_LIMIT = 200

      @subscribers ||= {}
      @recent ||= []
      @last_error = nil
      @next_id ||= 0

      class << self

        # @return [Exception, nil]
        attr_reader :last_error

        # @param prefix [String] topics starting with it ('' = everything)
        # @yieldparam event [Event]
        # @return [Integer] id for {.unsubscribe}
        def subscribe(prefix = '', &block)
          raise ArgumentError, 'block is required' unless block

          @next_id += 1
          @subscribers[@next_id] = [prefix.to_s, block]
          @next_id
        end

        # @param id [Integer]
        def unsubscribe(id)
          @subscribers.delete(id)
        end

        # @param topic [String] dotted, e.g. "action.completed"
        # @param payload [Hash] plain JSON data
        # @return [Event]
        def publish(topic, payload = {})
          event = Event.new(topic: topic.to_s, payload: payload, at: Time.now)
          @recent << event
          @recent.shift while @recent.size > RECENT_LIMIT
          @subscribers.each_value do |prefix, block|
            next unless event.topic.start_with?(prefix)

            begin
              block.call(event)
            rescue StandardError => error
              @last_error = error
            end
          end
          event
        end

        # @param prefix [String]
        # @return [Array<Event>] oldest first
        def recent(prefix = '')
          @recent.select { |event| event.topic.start_with?(prefix) }
        end

        # Removes subscribers and history. For tests.
        def clear
          @subscribers.clear
          @recent.clear
          @last_error = nil
        end

      end

    end
  end
end
