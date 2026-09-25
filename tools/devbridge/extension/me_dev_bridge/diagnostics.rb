# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Error audit of this SketchUp (asked for by the machine owner): every
    # error goes to the local {ErrorJournal} first and then, when configured,
    # to the studio platform (/admin/laboratorio/erros), so errors seen during
    # the day can be reviewed later with their details.
    #
    # Sources:
    # - console: anything written to the Ruby Console that looks like an error
    #   (SketchUp, V-Ray, any extension), through a tap on SKETCHUP_CONSOLE.
    #   Development-only by nature: a published extension must not touch the
    #   console, which is one more reason this lives in the Dev Bridge.
    # - bridge: errors of the bridge itself (e.g. Start failing).
    # - toolkit: failures our extensions publish on their event bus.
    # - crash: a previous session that ended without closing normally.
    #
    # Everything here swallows its own errors: diagnostics must never break
    # SketchUp or the console.
    module Diagnostics

      TICK_SECONDS = 20
      RECORDING = :me_dev_bridge_recording

      class << self

        # Idempotent: safe to call again after a development reload.
        #
        # @param data_dir [String]
        # @param config [Config]
        # @return [Boolean]
        def install(data_dir:, config:)
          dir = File.join(data_dir, 'errors')
          @journal ||= ErrorJournal.new(dir)
          @parser ||= ConsoleParser.new { |error| from_console(error) }
          @uploader ||= ErrorUploader.new(journal: @journal, config: config, post: ErrorUploader.method(:sketchup_post))
          ::SKETCHUP_CONSOLE.singleton_class.prepend(ConsoleTap) if defined?(::SKETCHUP_CONSOLE) && !console_tapped?
          open_session(SessionMarkers.new(dir)) unless @session_open
          @timer ||= UI.start_timer(TICK_SECONDS, true) { tick }
          true
        rescue StandardError => error
          warn("[Dev Bridge] diagnostics disabled: #{error.class}: #{error.message}")
          false
        end

        # @param error [Exception]
        def record_exception(error, source:, context: {})
          record(source: source, kind: error.class.name, message: error.message,
                 backtrace: Array(error.backtrace), context: context)
        end

        # @return [Hash, nil] the stored entry
        def record(source:, kind:, message:, backtrace: [], context: {})
          return unless @journal

          busy do
            @journal.record(source: source, kind: kind, message: message, backtrace: backtrace,
                            **ErrorContext.fields, context: ErrorContext.environment.merge(context))
          end
        end

        # Called by {ConsoleTap}. Text printed while an error is being
        # recorded is ours and is skipped.
        def console(text)
          return if !@parser || Thread.current[RECORDING]

          guarded { @parser.feed(text) }
        end

        # Subscribes to the failures our extensions publish; a no-op when the
        # toolkit is absent or already watched.
        def watch_toolkit
          events = defined?(::MuriloEduardo::VRayToolkit::Events) && ::MuriloEduardo::VRayToolkit::Events
          return if !events || @toolkit_events.equal?(events)

          @toolkit_events = events
          ToolkitErrors::TOPICS.each do |topic|
            events.subscribe(topic) do |event|
              entry = ToolkitErrors.to_record(event.topic, event.payload)
              record(**entry) if entry
            end
          end
        end

        # Runs on a timer: flushes the console parser and delivers the journal.
        def tick
          guarded { watch_toolkit }
          guarded { @parser&.flush }
          guarded { @uploader&.tick }
        end

        # Normal exit: last flush, and the session marker goes away.
        def close
          guarded { @parser&.flush }
          guarded { @markers&.close }
        end

        # @return [Hash] for the bridge status (`su ping`)
        def summary
          {
            journal: @journal&.path,
            pending: @journal ? @journal.pending(1_000_000).items.size : 0,
            last_upload: @uploader&.last,
            console_tap: console_tapped? || false,
          }
        end

        private

        def console_tapped? = defined?(::SKETCHUP_CONSOLE) && ::SKETCHUP_CONSOLE.singleton_class.include?(ConsoleTap)

        def open_session(markers)
          @session_open = true
          @markers = markers
          markers.open(sketchup_version: Sketchup.version.to_s).each do |dead|
            record(source: 'crash', kind: 'UnexpectedExit',
                   message: "O SketchUp fechou sem encerrar normalmente (sessão iniciada em #{dead['started_at']}, " \
                            "processo #{dead['pid']}).",
                   context: { previous_session: dead, last_errors: last_errors_since(dead['started_at']) })
          end
          Sketchup.add_observer(QuitObserver.new)
        end

        # What the journal says happened in that session, to explain the crash.
        def last_errors_since(started_at)
          @journal.recent(10).select { |entry| entry['at'].to_s >= started_at.to_s }
                  .map { |entry| entry.slice('at', 'source', 'kind', 'message') }
        end

        def from_console(error)
          record(source: 'console', kind: error[:kind], message: error[:message], backtrace: error[:backtrace],
                 context: { console_tail: error[:tail].last(15) })
        end

        # A failure in diagnostics must not reach the caller (the console, a
        # timer, SketchUp).
        def guarded
          yield
        rescue StandardError
          nil
        end

        # Marks the recording so {console} ignores what it prints (a warning
        # from JSON or the file system would otherwise be parsed again).
        def busy(&)
          previous = Thread.current[RECORDING]
          Thread.current[RECORDING] = true
          guarded(&)
        ensure
          Thread.current[RECORDING] = previous
        end

      end

      # Deletes the session marker when SketchUp closes normally.
      class QuitObserver < Sketchup::AppObserver

        def onQuit # rubocop:disable Naming/MethodName -- SketchUp observer callback name.
          Diagnostics.close
        end

      end

    end
  end
end
