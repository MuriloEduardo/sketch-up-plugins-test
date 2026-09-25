# frozen_string_literal: true

require 'tmpdir'

module MuriloEduardoDev
  module DevBridge
    # SketchUp processes on this Windows machine and whether each has a window.
    # A SketchUp.exe without a window is a "ghost": the user closed it, the
    # window went away, but the process never ended (it keeps memory and, if
    # it ran the bridge, the bridge port).
    #
    # Parsing is pure Ruby (unit tested). Commands run hidden through
    # WScript.Shell, so no console window flashes inside SketchUp.
    module WindowsProcesses

      LIST_SKETCHUP = 'powershell -NoProfile -NonInteractive -Command "Get-Process -Name SketchUp ' \
                      '-ErrorAction SilentlyContinue | ForEach-Object { \'{0} {1} {2}\' -f $_.Id, ' \
                      '[int64]$_.MainWindowHandle, $_.StartTime.ToString(\'s\') }"'
      HIDDEN = 0

      # @param text [String] output of {LIST_SKETCHUP}: "pid window_handle start" per line
      # @return [Array<Hash>] pid:, window:, started_at:
      def self.parse(text)
        text.b.each_line.filter_map do |line|
          pid, handle, started = line.split
          next unless pid&.match?(/\A\d+\z/) && handle&.match?(/\A-?\d+\z/)

          { pid: Integer(pid), window: Integer(handle) != 0, started_at: started }
        end
      end

      # @param processes [Array<Hash>] from {.parse}
      # @param self_pid [Integer]
      # @return [Array<Hash>] other SketchUps without a window
      def self.ghosts(processes, self_pid)
        processes.reject { |process| process[:pid] == self_pid || process[:window] }
      end

      # @return [Array<Hash>] SketchUp processes now (empty off Windows)
      def self.sketchup
        parse(capture(LIST_SKETCHUP))
      end

      # Runs a command hidden and returns its output (bytes, console code page).
      #
      # @param command [String]
      # @return [String]
      def self.capture(command)
        return '' unless Gem.win_platform?

        require 'win32ole'
        output = File.join(Dir.tmpdir, "me_dev_bridge_#{Process.pid}_#{Random.rand(1_000_000_000)}.txt")
        WIN32OLE.new('WScript.Shell').Run(%(cmd /c #{command} > "#{output}" 2>&1), HIDDEN, true)
        File.exist?(output) ? File.binread(output) : ''
      ensure
        File.delete(output) if output && File.exist?(output)
      end

    end
  end
end
