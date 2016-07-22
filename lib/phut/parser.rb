# frozen_string_literal: true
require 'phut/link'
require 'phut/syntax'
require 'phut/vhost'
require 'phut/vswitch'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(file)
      @file = file
      @netns = []
    end

    def parse
      Syntax.new(@netns).instance_eval IO.read(@file), @file
      Link.all.each do |link|
        Vswitch.select { |each| link.connect_to?(each) }.each do |vswitch|
          vswitch.add_port link.device(vswitch.name)
        end
      end
      Vhost.connect_link
      update_netns_interfaces
    end

    private

    def update_netns_interfaces
      @netns.each do |each|
        netns =
          Netns.create(name: each[:name],
                       ip_address: each[:ip], netmask: each[:netmask],
                       route: { net: each[:net], gateway: each[:gateway] },
                       vlan: each[:vlan])
        netns.device = find_network_device(each.name)
      end
    end

    def find_network_device(name)
      Link.all.each do |each|
        device = each.device(name)
        return device if device
      end
      nil
    end
  end
end
