require 'phut/vhost'
require 'phut/virtual_link'

module Phut
  # DSL syntax definitions.
  class Syntax
    # The 'vswitch(name) { ...attributes... }' directive.
    class VswitchDirective
      def initialize(alias_name, &block)
        @attributes = { name: alias_name }
        instance_eval(&block)
      end

      def dpid(value)
        dpid = if value.is_a?(String) && /^0x/=~ value
                 value.hex
               else
                 value.to_i
               end
        @attributes[:dpid] = dpid
        @attributes[:name] ||= format('%#x', @attributes[:dpid])
      end
      alias_method :datapath_id, :dpid

      def [](key)
        @attributes[key]
      end
    end

    # The 'vhost(name) { ...attributes... }' directive.
    class VhostDirective
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

      def initialize(alias_name, &block)
        @attributes = { name: alias_name }
        if block
          instance_eval(&block) if block
        else
          @attributes[:ip] = UnusedIpAddressSingleton.generate
        end
      end

      def ip(value)
        @attributes[:ip] = value
        @attributes[:name] ||= value
      end

      def promisc(on_off)
        @attributes[:promisc] = on_off
      end

      def [](key)
        @attributes[key]
      end
    end

    # The 'link name_a, name_b' directive.
    class LinkDirective
      # Generates an unique Link ID
      class LinkId
        def initialize
          init
        end

        def init
          @index = 0
        end

        def generate
          @index += 1
        end
      end

      LinkIdSingleton = LinkId.new

      def initialize(name_a, name_b, link_id)
        @attributes = {}
        @attributes[:name_a] = name_a
        @attributes[:name_b] = name_b
        link_id = LinkIdSingleton.generate
        @attributes[:device_a] = "link#{link_id}-0"
        @attributes[:device_b] = "link#{link_id}-1"
      end

      def [](key)
        @attributes[key]
      end
    end

    def initialize(config)
      @config = config
      LinkDirective::LinkIdSingleton.init
    end

    def vswitch(alias_name = nil, &block)
      attrs = VswitchDirective.new(alias_name, &block)
      @config.add_vswitch attrs[:name], attrs
    end

    def vhost(alias_name = nil, &block)
      attrs = VhostDirective.new(alias_name, &block)
      @config.add_vhost attrs[:name], attrs
    end

    def link(name_a, name_b)
      link_id = @config.links.size
      attrs = LinkDirective.new(name_a, name_b, link_id)
      @config.add_link name_a, attrs[:device_a], name_b, attrs[:device_b]
    end
  end
end
