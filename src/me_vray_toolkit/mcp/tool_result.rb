# frozen_string_literal: true

require 'json'

module MuriloEduardo
  module VRayToolkit
    module Mcp
      # Turns an action's Hash into an MCP tool result: the data as text and
      # as `structuredContent`, plus an image block when the action returned
      # `image: { data:, mime_type: }`.
      #
      # Pure Ruby: unit tested in the Docker toolchain.
      module ToolResult

        # @param result [Hash]
        # @return [Hash]
        def self.success(result)
          data = result.to_h
          image = data[:image] || data['image']
          structured = data.except(:image, 'image')
          content = [{ 'type' => 'text', 'text' => JSON.generate(structured) }]
          content << image_block(image) if image
          { 'content' => content, 'structuredContent' => structured, 'isError' => false }
        end

        # A failure the agent should read and recover from (not a protocol
        # error).
        #
        # @param message [String]
        # @return [Hash]
        def self.failure(message)
          { 'content' => [{ 'type' => 'text', 'text' => message }], 'isError' => true }
        end

        def self.image_block(image)
          { 'type' => 'image', 'data' => image[:data] || image['data'],
            'mimeType' => image[:mime_type] || image['mime_type'] || 'image/png', }
        end
        private_class_method :image_block

      end
    end
  end
end
