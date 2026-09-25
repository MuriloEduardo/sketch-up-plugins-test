# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Features
      module SceneAudit

        # Translations for {I18n.t}.
        STRINGS = {
          'en' => {
            menu_item: 'Scene Audit...',
            title: 'Scene Audit',
            summary: 'Summary',
            findings: 'Findings',
            no_findings: 'No problems found.',
            col_severity: 'Severity',
            col_item: 'Item',
            col_detail: 'Detail',
            col_value: 'Value',
            severity_error: 'Error',
            severity_warning: 'Warning',
            severity_info: 'Info',
            sketchup_version: 'SketchUp',
            vray_version: 'V-Ray',
            vray_not_loaded: 'not loaded',
            materials: 'Materials (textured / unused)',
            vray_materials: 'V-Ray materials',
            vray_lights: 'V-Ray lights',
            file_references: 'Files referenced by V-Ray (missing)',
            missing_file: 'File not found at the stored path. Used by: %{plugins}',
            heavy_texture: '%{width} × %{height} px (above %{limit} px); slows down rendering and memory',
            unused_material: 'Not used by any entity in the model',
            vray_unavailable: 'V-Ray API is not loaded: V-Ray checks were skipped',
          },
          'pt-BR' => {
            menu_item: 'Auditoria de Cena...',
            title: 'Auditoria de Cena',
            summary: 'Resumo',
            findings: 'Ocorrências',
            no_findings: 'Nenhum problema encontrado.',
            col_severity: 'Gravidade',
            col_item: 'Item',
            col_detail: 'Detalhe',
            col_value: 'Valor',
            severity_error: 'Erro',
            severity_warning: 'Atenção',
            severity_info: 'Info',
            sketchup_version: 'SketchUp',
            vray_version: 'V-Ray',
            vray_not_loaded: 'não carregado',
            materials: 'Materiais (com textura / sem uso)',
            vray_materials: 'Materiais V-Ray',
            vray_lights: 'Luzes V-Ray',
            file_references: 'Arquivos usados pelo V-Ray (faltando)',
            missing_file: 'Arquivo não encontrado no caminho gravado. Usado por: %{plugins}',
            heavy_texture: '%{width} × %{height} px (acima de %{limit} px); deixa o render e a memória mais pesados',
            unused_material: 'Nenhuma entidade do modelo usa este material',
            vray_unavailable: 'A API do V-Ray não está carregada: verificações do V-Ray puladas',
          },
          'es' => {
            menu_item: 'Auditoría de Escena...',
            title: 'Auditoría de Escena',
            summary: 'Resumen',
            findings: 'Hallazgos',
            no_findings: 'No se encontraron problemas.',
            col_severity: 'Gravedad',
            col_item: 'Elemento',
            col_detail: 'Detalle',
            col_value: 'Valor',
            severity_error: 'Error',
            severity_warning: 'Aviso',
            severity_info: 'Info',
            sketchup_version: 'SketchUp',
            vray_version: 'V-Ray',
            vray_not_loaded: 'no cargado',
            materials: 'Materiales (con textura / sin uso)',
            vray_materials: 'Materiales V-Ray',
            vray_lights: 'Luces V-Ray',
            file_references: 'Archivos usados por V-Ray (faltantes)',
            missing_file: 'Archivo no encontrado en la ruta guardada. Usado por: %{plugins}',
            heavy_texture: '%{width} × %{height} px (más de %{limit} px); hace el render y la memoria más pesados',
            unused_material: 'Ninguna entidad del modelo usa este material',
            vray_unavailable: 'La API de V-Ray no está cargada: se omitieron las verificaciones de V-Ray',
          },
        }.freeze

      end
    end
  end
end
