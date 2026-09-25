# frozen_string_literal: true

require 'sketchup'
require 'extensions'

# DEVELOPMENT ONLY. Lets a development machine on the local network sync,
# reload, inspect and test extensions in this SketchUp over authenticated HTTP.
# It executes arbitrary Ruby by design: never install it on a user's machine.
module MuriloEduardoDev
  module DevBridge

    unless file_loaded?(__FILE__)
      EXTENSION = SketchupExtension.new('Dev Bridge (DEV ONLY)', 'me_dev_bridge/main')
      EXTENSION.description = 'Development-only remote bridge. Executes Ruby sent over the network.'
      EXTENSION.version     = '0.1.1'
      EXTENSION.copyright   = 'Murilo Eduardo © 2026'
      EXTENSION.creator     = 'Murilo Eduardo'
      Sketchup.register_extension(EXTENSION, true)
      file_loaded(__FILE__)
    end

  end
end
