# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module PlatformLink

        # Translations for {I18n.t}.
        STRINGS = {
          'en' => {
            menu_connect: 'Connect to the Platform...',
            menu_disconnect: 'Disconnect from the Platform',
            menu_status: 'Platform Connection Status',
            title: 'Connect to the Platform',
            prompt_url: 'Platform address',
            prompt_code: 'Code (My account › SketchUp)',
            linking: 'Connecting…',
            linked: 'This SketchUp is now connected to your account. The studio chat and your AI agents can use it ' \
                    'while SketchUp is open.',
            link_failed: 'Could not connect: %{error}',
            disconnected: 'This SketchUp is no longer connected to the platform.',
            not_linked: 'Not connected. Use "Connect to the Platform…" with a code from My account › SketchUp.',
            status: "Connected to %{url}.\nLast contact: %{contact}.%{error}",
            revoked: 'The link was removed on the platform. Connect again with a new code.',
            never: 'not yet',
          },
          'pt-BR' => {
            menu_connect: 'Conectar à plataforma...',
            menu_disconnect: 'Desconectar da plataforma',
            menu_status: 'Status da conexão com a plataforma',
            title: 'Conectar à plataforma',
            prompt_url: 'Endereço da plataforma',
            prompt_code: 'Código (Minha conta › SketchUp)',
            linking: 'Conectando…',
            linked: 'Este SketchUp agora está ligado à sua conta. O chat do estúdio e seus agentes de IA ' \
                    'podem usá-lo enquanto o SketchUp estiver aberto.',
            link_failed: 'Não foi possível conectar: %{error}',
            disconnected: 'Este SketchUp não está mais ligado à plataforma.',
            not_linked: 'Não conectado. Use "Conectar à plataforma…" com um código de Minha conta › SketchUp.',
            status: "Conectado a %{url}.\nÚltimo contato: %{contact}.%{error}",
            revoked: 'A ligação foi removida na plataforma. Conecte de novo com um código novo.',
            never: 'ainda não',
          },
          'es' => {
            menu_connect: 'Conectar a la plataforma...',
            menu_disconnect: 'Desconectar de la plataforma',
            menu_status: 'Estado de la conexión con la plataforma',
            title: 'Conectar a la plataforma',
            prompt_url: 'Dirección de la plataforma',
            prompt_code: 'Código (Mi cuenta › SketchUp)',
            linking: 'Conectando…',
            linked: 'Este SketchUp ya está conectado a tu cuenta. El chat del estudio y tus agentes de IA ' \
                    'pueden usarlo mientras SketchUp esté abierto.',
            link_failed: 'No se pudo conectar: %{error}',
            disconnected: 'Este SketchUp ya no está conectado a la plataforma.',
            not_linked: 'No conectado. Usa "Conectar a la plataforma…" con un código de Mi cuenta › SketchUp.',
            status: "Conectado a %{url}.\nÚltimo contacto: %{contact}.%{error}",
            revoked: 'La conexión fue eliminada en la plataforma. Conecta de nuevo con un código nuevo.',
            never: 'todavía no',
          },
        }.freeze

      end
    end
  end
end
