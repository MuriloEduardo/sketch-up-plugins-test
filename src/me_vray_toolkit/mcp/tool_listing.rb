# frozen_string_literal: true

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # How an {Actions::Action} is published in `tools/list`: name, title,
      # description, JSON Schema of the input and behavior hints.
      #
      # Pure Ruby (needs {Params}): unit tested in the Docker toolchain.
      module ToolListing

        # @param action [Actions::Action]
        # @return [Hash]
        def self.describe(action)
          {
            'name' => action.name,
            'title' => action.title,
            'description' => action.description,
            'inputSchema' => Params.json_schema(action.schema),
            'annotations' => {
              'title' => action.title,
              'readOnlyHint' => action.read_only ? true : false,
              'destructiveHint' => action.destructive ? true : false,
              'idempotentHint' => action.idempotent ? true : false,
              'openWorldHint' => false,
            },
          }
        end

      end
    end
  end
end
