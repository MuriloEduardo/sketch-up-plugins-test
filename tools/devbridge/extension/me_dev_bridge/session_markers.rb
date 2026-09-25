# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'time'

module MuriloEduardoDev
  module DevBridge
    # Detects SketchUp sessions that ended without closing normally (crash,
    # freeze killed from the Task Manager, power loss). Each running SketchUp
    # keeps a marker file named after its process id; closing normally
    # deletes it. A marker left behind by a process that no longer exists is a
    # session that died. One file per process because SketchUp on Windows can
    # run several instances at once.
    #
    # Pure Ruby (unit tested); process liveness is injected.
    class SessionMarkers

      PREFIX = 'session-'

      # @param dir [String]
      # @param pid [Integer] this process
      # @param alive [#call] (pid) → Boolean
      # @param clock [#call] current Time
      def initialize(dir, pid: Process.pid, alive: ->(other) { self.class.alive?(other) }, clock: -> { Time.now })
        @dir = dir
        @pid = pid
        @alive = alive
        @clock = clock
      end

      # @param pid [Integer]
      # @return [Boolean]
      def self.alive?(pid)
        Process.kill(0, pid)
        true
      rescue Errno::ESRCH
        false
      rescue Errno::EPERM
        true
      end

      # Records this session and collects the dead ones (removing their markers).
      #
      # @param info [Hash] stored in the marker (versions, start time…)
      # @return [Array<Hash>] markers of sessions that died, oldest first
      def open(info = {})
        dead = markers.reject { |marker| marker['pid'] == @pid || @alive.call(marker['pid']) }
        dead.each { |marker| FileUtils.rm_f(marker_path(marker['pid'])) }
        FileUtils.mkdir_p(@dir)
        File.write(marker_path(@pid), JSON.generate(info.merge(pid: @pid, started_at: @clock.call.iso8601)))
        dead.sort_by { |marker| marker['started_at'].to_s }
      end

      # Normal exit.
      def close
        FileUtils.rm_f(marker_path(@pid))
      end

      private

      def markers
        Dir.glob(File.join(@dir, "#{PREFIX}*.json")).filter_map do |file|
          data = JSON.parse(File.read(file))
          data.is_a?(Hash) && data['pid'].is_a?(Integer) ? data : nil
        rescue JSON::ParserError
          FileUtils.rm_f(file)
          nil
        end
      end

      def marker_path(pid) = File.join(@dir, "#{PREFIX}#{pid}.json")

    end
  end
end
