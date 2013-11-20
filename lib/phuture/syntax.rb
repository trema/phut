# -*- coding: utf-8 -*-
require 'phuture/open_vswitch'
require 'phuture/phost'

module Phuture
  # DSL syntax definitions.
  class Syntax
    # The 'vswitch(name) { ...attributes...}' directive.
    class Vswitch
      def initialize
        @attributes = {}
      end

      def dpid(value)
        @attributes[:dpid] = value
      end

      def [](key)
        @attributes[key]
      end
    end

    # The 'vhost(name) { ...attributes...}' directive.
    class Vhost
      def initialize
        @attributes = {}
      end

      def ip(value)
        @attributes[:ip] = value
      end

      def [](key)
        @attributes[key]
      end
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def vswitch(&block)
      vswitch = Vswitch.new
      vswitch.instance_eval(&block)
      @configuration.vswitch << OpenVswitch.new(vswitch[:dpid])
    end

    def vhost(&block)
      vhost = Vhost.new
      vhost.instance_eval(&block)
      @configuration.vhost << Phost.new(vhost[:ip])
    end
  end
end
