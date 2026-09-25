# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module RenderNotifications

        # Translations for {I18n.t}.
        STRINGS = {
          'en' => {
            started: 'Render started: %{what} (%{size}) at %{time}',
            done: 'Render finished: %{what} in %{seconds} s',
            done_time_limit: 'Render finished (time limit reached): %{what} in %{seconds} s',
            failed: 'Render failed: %{what}. %{error}',
            cancelled: 'Render cancelled: %{what}',
            batch_started: 'Batch render started: %{count} scenes at %{time}',
            batch_done: 'Batch render finished: %{summary} in %{seconds} s',
            running: 'V-Ray rendering %{what}: %{message}',
            current_view: 'current view',
            open_folder: 'Open folder',
          },
          'pt-BR' => {
            started: 'Render iniciado: %{what} (%{size}) às %{time}',
            done: 'Render concluído: %{what} em %{seconds} s',
            done_time_limit: 'Render concluído (limite de tempo): %{what} em %{seconds} s',
            failed: 'Render falhou: %{what}. %{error}',
            cancelled: 'Render cancelado: %{what}',
            batch_started: 'Render em lote iniciado: %{count} cenas às %{time}',
            batch_done: 'Render em lote concluído: %{summary} em %{seconds} s',
            running: 'V-Ray renderizando %{what}: %{message}',
            current_view: 'vista atual',
            open_folder: 'Abrir pasta',
          },
          'es' => {
            started: 'Render iniciado: %{what} (%{size}) a las %{time}',
            done: 'Render terminado: %{what} en %{seconds} s',
            done_time_limit: 'Render terminado (límite de tiempo): %{what} en %{seconds} s',
            failed: 'Render fallido: %{what}. %{error}',
            cancelled: 'Render cancelado: %{what}',
            batch_started: 'Render por lotes iniciado: %{count} escenas a las %{time}',
            batch_done: 'Render por lotes terminado: %{summary} en %{seconds} s',
            running: 'V-Ray renderizando %{what}: %{message}',
            current_view: 'vista actual',
            open_folder: 'Abrir carpeta',
          },
        }.freeze

        # Turns job events into the sentences shown to the user.
        #
        # Pure Ruby (needs {I18n} and STRINGS): unit tested in the Docker
        # toolchain.
        module Messages

          # @param topic [String] "job.running", "job.done"…
          # @param job [Hash] {Jobs::Job#to_h}
          # @return [String, nil] nil for events that need no notice
          def self.notice(topic, job)
            return nil unless %w[render render_batch].include?(job[:kind])

            batch = job[:kind] == 'render_batch'
            case topic
            when 'job.running' then started(job, batch) if job[:progress].nil? || job[:progress].zero?
            when 'job.done' then finished(job, batch)
            when 'job.failed' then t(:failed, what: what(job), error: job[:error])
            when 'job.cancelled' then t(:cancelled, what: what(job))
            end
          end

          # @return [String] for the status bar while it runs
          def self.status(job)
            t(:running, what: what(job), message: job[:message])
          end

          def self.started(job, batch)
            time = job[:started_at].to_s[11, 5]
            return t(:batch_started, count: job[:details][:scenes].size, time: time) if batch

            t(:started, what: what(job), size: "#{job[:details][:width]}×#{job[:details][:height]}", time: time)
          end

          def self.finished(job, batch)
            seconds = job[:elapsed_seconds].round
            return t(:batch_done, summary: job[:message], seconds: seconds) if batch

            key = job[:message].to_s.include?('time limit') ? :done_time_limit : :done
            t(key, what: what(job), seconds: seconds)
          end

          def self.what(job)
            job[:details][:scene] || t(:current_view)
          end

          def self.t(key, **values)
            I18n.t(STRINGS, key, **values)
          end

          private_class_method :started, :finished, :what, :t

        end

      end
    end
  end
end
