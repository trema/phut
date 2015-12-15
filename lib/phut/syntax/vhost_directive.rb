require 'phut/syntax/directive'

module Phut
  class Syntax
    # The 'vhost(name) { ...attributes... }' directive.
    class VhostDirective < Directive
      # Generates an unused IP address
      class UnusedIpAddress
        def initialize
          @index = 0
        end

        def generate
          @index += 1
          "192.168.0.#{@index}"
        end
      end

      UnusedIpAddressSingleton = UnusedIpAddress.new

      attribute :mac
      attribute :promisc

      def initialize(alias_name, &block)
        @attributes =
          { name: alias_name,
            mac: Pio::Mac.new(rand(0xffffffffffff + 1)),
            promisc: false }
        if block
          instance_eval(&block)
        else
          @attributes[:ip] = UnusedIpAddressSingleton.generate
        end
      end

      def ip(value)
        @attributes[:ip] = value
        @attributes[:name] ||= value
      end
    end
  end
end
