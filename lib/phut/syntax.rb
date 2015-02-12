require 'phut/phost'
require 'phut/virtual_link'

module Phut
  # DSL syntax definitions.
  class Syntax
    # The 'vswitch(name) { ...attributes...}' directive.
    class VswitchDirective
      def initialize
        @attributes = {}
      end

      def dpid(value)
        @attributes[:dpid] = case value
                             when String
                               /^0x/ =~ value ? value.hex : value.to_i
                             else
                               value.to_i
                             end
      end
      alias_method :datapath_id, :dpid

      def [](key)
        @attributes[key]
      end
    end

    # The 'vhost(name) { ...attributes...}' directive.
    class VhostDirective
      def initialize
        @attributes = {}
      end

      def ip(value)
        @attributes[:ip] = value
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
      def initialize(name_a, name_b, link_id)
        @attributes = {}.tap do |attr|
          attr[:name_a] = name_a
          attr[:name_b] = name_b
          attr[:device_a] = "link#{link_id}-0"
          attr[:device_b] = "link#{link_id}-1"
        end
      end

      def [](key)
        @attributes[key]
      end
    end

    def initialize(config)
      @config = config
    end

    def vswitch(alias_name = nil, &block)
      attrs = VswitchDirective.new.tap { |vsw| vsw.instance_eval(&block) }
      @config.add_vswitch(alias_name || format('%#x', attrs[:dpid]), attrs)
    end

    def vhost(alias_name = nil, &block)
      if block
        attrs = VhostDirective.new.tap { |vh| vh.instance_eval(&block) }
        @config.add_vhost(alias_name || attrs[:ip], attrs)
      else
        @vhost_id ||= 0
        @config.add_vhost(alias_name, ip: "192.168.0.#{@vhost_id += 1}")
      end
    end

    def link(name_a, name_b)
      attrs = LinkDirective.new(name_a, name_b, @config.next_link_id)
      @config.add_link name_a, attrs[:device_a], name_b, attrs[:device_b]
    end
  end
end
