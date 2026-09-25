# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Who holds a TCP port on Windows, to explain a failed Start ("port in
    # use") with the process to close instead of a bare socket error. Usually
    # another SketchUp.exe: a second window opened from a .skp, or a frozen
    # instance still running in the background.
    #
    # Parsing is pure Ruby (unit tested); {.lookup} shells out and only runs
    # on Windows, only after a failure.
    module PortOwner

      # A listening socket has no remote end, whatever the Windows language
      # calls its state (LISTENING, ESCUTANDO, ABHÖREN…).
      NO_REMOTE = /\A(?:0\.0\.0\.0|\[::\]):0\z/

      # @param netstat [String] output of `netstat -ano -p tcp`, in the console
      #   code page (read as bytes: localized headers are not UTF-8)
      # @param port [Integer]
      # @return [Integer, nil] pid listening on that port
      def self.listening_pid(netstat, port)
        netstat.b.each_line do |line|
          fields = line.split
          next unless fields.size >= 5 && fields[0].casecmp?('TCP')
          next unless fields[1].end_with?(":#{port}") && NO_REMOTE.match?(fields[2])

          return Integer(fields[4], exception: false)
        end
        nil
      end

      # @param pid [Integer]
      # @return [String] CSV without header, one line per process
      def self.tasklist_command(pid) = %(tasklist /FI "PID eq #{Integer(pid)}" /FO CSV /NH)

      # @param tasklist [String] output of {.tasklist_command}
      # @return [String, nil] image name, e.g. "SketchUp.exe"
      def self.image_name(tasklist)
        first = tasklist.b.lines.find { |line| line.start_with?('"') }
        first && first.split('","').first.delete('"')
      end

      # What to tell the user when Start fails.
      #
      # @param error [Exception]
      # @param owner [Hash, nil] from {.lookup}
      # @param address [String] "127.0.0.1:7860"
      # @return [String]
      def self.explain(error, owner, address)
        lines = ["Could not start on #{address}: #{error.class}: #{error.message}"]
        if owner && owner[:same_process]
          lines << 'This SketchUp already holds the port: the bridge is probably running. Use Connection Info.'
        elsif owner
          lines << "The port is held by #{owner[:name] || 'another program'} (PID #{owner[:pid]}" \
                   "#{', with a window: it may hold unsaved work, so it was not ended' if owner[:window]})."
          lines << 'If it is another SketchUp window, close it (or end it in the Task Manager if it is frozen) ' \
                   'and Start again.'
        end
        lines << 'This error was recorded in the error audit (Dev Bridge > Open Error Log Folder).'
        lines.join("\n")
      end

      # @param port [Integer]
      # @return [Hash, nil] pid:, name:, same_process:, window: (nil when unknown)
      def self.lookup(port)
        return unless Gem.win_platform?

        pid = listening_pid(WindowsProcesses.capture('netstat -ano -p tcp'), port)
        return unless pid

        sketchup = WindowsProcesses.sketchup.find { |process| process[:pid] == pid }
        name = sketchup ? 'SketchUp.exe' : image_name(WindowsProcesses.capture(tasklist_command(pid)))
        { pid: pid, name: name, same_process: pid == Process.pid, window: sketchup&.fetch(:window) }
      end

    end
  end
end
