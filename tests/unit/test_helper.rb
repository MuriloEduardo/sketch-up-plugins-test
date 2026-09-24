# frozen_string_literal: true

require 'minitest/autorun'

# Raiz do código das extensões. Carregue arquivos puros com:
#   require_source 'me_vray_toolkit/vray/quality_preset'
SOURCE_ROOT = File.expand_path('../../src', __dir__)

# Raiz da extensão de desenvolvimento Dev Bridge.
DEVBRIDGE_ROOT = File.expand_path('../../tools/devbridge/extension', __dir__)

def require_source(path)
  require File.join(SOURCE_ROOT, path)
end

def require_devbridge(*names)
  names.each { |name| require File.join(DEVBRIDGE_ROOT, 'me_dev_bridge', name) }
end
