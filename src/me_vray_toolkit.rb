# frozen_string_literal: true

require 'sketchup'
require 'extensions'

# Arquivo raiz: SOMENTE registra a extensão (exigência do Extension Warehouse).
# Toda a lógica vive em me_vray_toolkit/ e só é carregada se a extensão
# estiver habilitada no Extension Manager.
module MuriloEduardo
  module VRayToolkit

    unless file_loaded?(__FILE__)
      EXTENSION = SketchupExtension.new('V-Ray Toolkit', 'me_vray_toolkit/main')
      EXTENSION.description = 'Automation toolkit for SketchUp and V-Ray.'
      EXTENSION.version     = '0.3.0'
      EXTENSION.copyright   = 'Murilo Eduardo © 2026'
      EXTENSION.creator     = 'Murilo Eduardo'
      Sketchup.register_extension(EXTENSION, true)
      file_loaded(__FILE__)
    end

  end
end
