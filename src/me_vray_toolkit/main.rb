# frozen_string_literal: true

require 'sketchup'

Sketchup.require('me_vray_toolkit/core/commands')
Sketchup.require('me_vray_toolkit/core/i18n')
Sketchup.require('me_vray_toolkit/core/menu')
Sketchup.require('me_vray_toolkit/product')

module MuriloEduardo
  module VRayToolkit

    I18n.locale = Sketchup.get_locale

    # Each feature registers its commands in {Commands} when loaded.
    Product::FEATURES.each { |feature| Sketchup.require("me_vray_toolkit/features/#{feature}/feature") }

    unless file_loaded?(__FILE__)
      Menu.install(Product::NAME)
      file_loaded(__FILE__)
    end

  end
end
