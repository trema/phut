# -*- coding: utf-8 -*-
require 'phuture/open_vswitch'
require 'phuture/phost'
require 'phuture/virtual_link'

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

    # The 'link peer_a, peer_b' directive.
    class Link
      attr_reader :peer_a
      attr_reader :peer_b
      attr_reader :name_a
      attr_reader :name_b

      def initialize(peer_a, peer_b, link_id)
        @peer_a = peer_a
        @peer_b = peer_b
        @name_a = "phut#{link_id}-0"
        @name_b = "phut#{link_id}-1"
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

    def link(peer_a, peer_b)
      link_id = @configuration.link.size
      link = Link.new(peer_a, peer_b, link_id)
      @configuration.link << VirtualLink.new(peer_a, link.name_a,
                                             peer_b, link.name_b)
    end
  end
end
