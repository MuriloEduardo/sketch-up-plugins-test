# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Deals with ghost SketchUps (see {WindowsProcesses}): reports them to the
    # error audit when SketchUp opens, and ends the one holding the bridge
    # port so Start works. Only windowless SketchUp.exe processes other than
    # this one are ever ended: a SketchUp with a window may hold unsaved work.
    module GhostWatch

      SCAN_DELAY_SECONDS = 15
      RELEASE_TRIES = 20
      RELEASE_WAIT_SECONDS = 0.25

      # @param owner_pid [Integer, nil] process listening on the port
      # @param processes [Array<Hash>] from {WindowsProcesses.parse}
      # @param self_pid [Integer]
      # @return [Hash, nil] the ghost that may be ended
      def self.reclaimable(owner_pid, processes, self_pid)
        WindowsProcesses.ghosts(processes, self_pid).find { |process| process[:pid] == owner_pid }
      end

      # Counts ghosts once SketchUp finished opening (its own window exists by then).
      def self.scan_later
        UI.start_timer(SCAN_DELAY_SECONDS, false) { scan }
      end

      def self.scan
        ghosts = WindowsProcesses.ghosts(WindowsProcesses.sketchup, Process.pid)
        return if ghosts.empty?

        Diagnostics.record(source: 'crash', kind: 'GhostSketchUpProcesses',
                           message: "#{ghosts.size} SketchUp.exe sem janela continuam rodando (fechados sem " \
                                    "terminar): PIDs #{ghosts.map { |ghost| ghost[:pid] }.join(', ')}.",
                           context: { ghosts: ghosts, detected_by: 'bridge startup scan' })
      rescue StandardError => error
        Diagnostics.record_exception(error, source: 'bridge', context: { action: 'ghost scan' })
      end

      # Ends the ghost SketchUp holding the port, if that is what holds it.
      #
      # @param port [Integer]
      # @return [Hash, nil] the ended process
      def self.reclaim(port)
        owner = PortOwner.listening_pid(WindowsProcesses.capture('netstat -ano -p tcp'), port)
        ghost = reclaimable(owner, WindowsProcesses.sketchup, Process.pid)
        return unless ghost

        Process.kill('KILL', ghost[:pid])
        Diagnostics.record(source: 'bridge', kind: 'GhostSketchUpKilled',
                           message: "SketchUp sem janela (PID #{ghost[:pid]}, aberto em #{ghost[:started_at]}) " \
                                    "segurava a porta #{port} da Dev Bridge e foi encerrado.",
                           context: { port: port, ghost: ghost })
        ghost
      end

      # @yield tries to listen again; raises Errno::EADDRINUSE while the port is not free
      # @return [Boolean] listening
      def self.listening_after_retries?
        RELEASE_TRIES.times do
          yield
          return true
        rescue Errno::EADDRINUSE
          sleep(RELEASE_WAIT_SECONDS)
        end
        false
      end

    end
  end
end
