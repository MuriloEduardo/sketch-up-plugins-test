# frozen_string_literal: true

module MuriloEduardoDev
  module DevBridge
    # Tap on the Ruby Console (prepended to SKETCHUP_CONSOLE's singleton
    # class by {Diagnostics}). Whether SketchUp's `puts`/`print` go through
    # `write` is not documented, so the tap notes when it is already inside
    # one of them and hands each text over once.
    module ConsoleTap

      INSIDE = :me_dev_bridge_tap

      # What `puts` would print for these arguments. Pure (unit tested).
      #
      # @param method [Symbol] :write, :print or :puts
      # @param args [Array]
      # @return [String]
      def self.text(method, args)
        return args.join unless method == :puts
        return "\n" if args.empty?

        args.flatten.map(&:to_s).map { |line| line.end_with?("\n") ? line : "#{line}\n" }.join
      end

      %i[write print puts].each do |name|
        define_method(name) do |*args|
          Diagnostics.console(ConsoleTap.text(name, args)) unless Thread.current[INSIDE]
          begin
            Thread.current[INSIDE] = true
            super(*args)
          ensure
            Thread.current[INSIDE] = false
          end
        end
      end

    end
  end
end
