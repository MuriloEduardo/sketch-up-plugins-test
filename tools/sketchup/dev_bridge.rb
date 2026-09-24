# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'stringio'

# Ponte de DESENVOLVIMENTO: executa trechos de Ruby enviados pelo terminal
# (WSL) dentro deste SketchUp e devolve o resultado em JSON.
#
# Protocolo por arquivos (sem rede — o NAT do WSL2 não alcança o 127.0.0.1 do
# Windows sem o modo "mirrored"):
#   <spool>/inbox/<id>.rb     código a executar (escrito atomicamente)
#   <spool>/outbox/<id>.json  resultado: ok, result (inspect), stdout, error...
#
# A execução acontece no thread principal via UI.start_timer, que é o único
# jeito seguro de chamar a API do SketchUp. Scripts longos travam a janela até
# terminar. Isto é execução arbitrária de código por design: só é carregado
# pelo loader de desenvolvimento e NUNCA faz parte de uma extensão publicada.
#
# Mesma ideia do "Claude Bridge" da comunidade (HTTP em 127.0.0.1:7857,
# forums.sketchup.com/t/349529), adaptada para WSL.
module MuriloEduardoDev
  module Bridge

    POLL_INTERVAL = 0.25
    BACKTRACE_LINES = 20

    # @param spool [String] pasta de spool (caminho Windows)
    def self.start(spool)
      @spool = spool
      @inbox = File.join(spool, 'inbox')
      @outbox = File.join(spool, 'outbox')
      FileUtils.mkdir_p([@inbox, @outbox])
      return if @timer

      @busy = false
      @timer = UI.start_timer(POLL_INTERVAL, true) { poll }
    end

    def self.stop
      UI.stop_timer(@timer) if @timer
      @timer = nil
    end

    def self.running?
      !@timer.nil?
    end

    # Processa no máximo um job por tick para manter a UI responsiva.
    def self.poll
      return if @busy

      job = Dir.glob(File.join(@inbox, '*.rb')).min
      return unless job

      @busy = true
      job_id = File.basename(job, '.rb')
      code = File.read(job, encoding: 'UTF-8')
      File.delete(job)
      write_result(job_id, execute(code, job_id))
    ensure
      @busy = false
    end

    # @return [Hash]
    def self.execute(code, job_id)
      output = StringIO.new
      original_stdout = $stdout
      $stdout = output
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      result = evaluate(code, job_id)
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
      result.merge(id: job_id, stdout: output.string, seconds: elapsed.round(4))
    ensure
      $stdout = original_stdout
    end

    # @return [Hash]
    def self.evaluate(code, job_id)
      value = fresh_binding.eval(code, "devbridge:#{job_id}")
      { ok: true, result: value.inspect, result_class: value.class.name }
    rescue Exception => error # rubocop:disable Lint/RescueException
      # ScriptError (SyntaxError, LoadError) também precisa voltar ao terminal.
      {
        ok: false,
        error: error.class.name,
        message: error.message,
        backtrace: Array(error.backtrace).first(BACKTRACE_LINES),
      }
    end

    def self.fresh_binding
      Object.new.instance_eval { binding }
    end

    def self.write_result(job_id, payload)
      temporary = File.join(@outbox, "#{job_id}.json.tmp")
      File.write(temporary, JSON.pretty_generate(payload))
      File.rename(temporary, File.join(@outbox, "#{job_id}.json"))
    end

  end
end
