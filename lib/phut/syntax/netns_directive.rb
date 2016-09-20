# frozen_string_literal: true
require 'phut/syntax/directive'

module Phut
  class Syntax
    # The 'netns(name) { ...attributes... }' directive.
    class NetnsDirective < Directive
      attribute :netmask

      def initialize(alias_name, &block)
        @attributes = { name: alias_name,
                        netmask: '255.255.255.255' }
        instance_eval(&block) if block
      end

      def ip(value)
        @attributes[:ip] = value
        @attributes[:name] ||= value
      end

      def route(options)
        @attributes[:net] = options.fetch(:net)
        @attributes[:gateway] = options.fetch(:gateway)
      end

      def mac(value)
        @attributes[:mac_address] = value
      end

      def vlan(value)
        @attributes[:vlan] = value
      end
    end
  end
end
