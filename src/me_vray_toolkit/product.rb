# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    # What this package contains. This source tree is the full product (every
    # feature); smaller products are derived from it by tools/build/package.rb
    # from products/*.json, which rewrites this file with their own values.
    module Product

      NAME = 'V-Ray Toolkit'

      # Folders under features/, loaded in this order.
      FEATURES = %w[scene_audit render_quality].freeze

    end
  end
end
