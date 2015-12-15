module Phut
  class Syntax
    # Common DSL directive
    class Directive
      def self.attribute(name)
        define_method(name) do |value|
          @attributes[name] = value
        end
      end

      def [](key)
        @attributes.fetch(key)
      end
    end
  end
end
