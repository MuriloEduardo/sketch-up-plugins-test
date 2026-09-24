# frozen_string_literal: true

require 'minitest/autorun'

# Raiz do código da extensão. Carregue arquivos puros com:
#   require_source 'me_vray_toolkit/vray/quality_preset'
SOURCE_ROOT = File.expand_path('../../src', __dir__)

def require_source(path)
  require File.join(SOURCE_ROOT, path)
end
