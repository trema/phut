# frozen_string_literal: true

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
        @attributes[key]
      end

      # rubocop:disable MethodMissing
      def method_missing(name)
        @attributes.fetch name.to_sym
      end
      # rubocop:enable MethodMissing
    end
  end
end
