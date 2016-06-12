# frozen_string_literal: true
require 'phut/link'
require 'phut/null_logger'
require 'phut/syntax'
require 'phut/vswitch'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(file, logger = NullLogger.new)
      @file = file
      @netns = []
      @logger = logger
    end

    def parse
      Syntax.new(@netns).instance_eval IO.read(@file), @file
      update_vswitch_ports
      update_vhost_interfaces
      update_netns_interfaces
    end

    private

    def update_vswitch_ports
      Link.each do |each|
        maybe_connect_link_to_vswitch each
      end
    end

    def maybe_connect_link_to_vswitch(link)
      Vswitch.select { |each| link.connect_to?(each) }.each do |each|
        each.add_port link.device(each.name)
      end
    end

    def update_vhost_interfaces
      Vhost.each do |each|
        each.device = find_network_device(each)
      end
    end

    def update_netns_interfaces
      @netns.each do |each|
        netns =
          Netns.create(name: each[:name],
                       ip_address: each[:ip], netmask: each[:netmask],
                       route: { net: each[:net], gateway: each[:gateway] })
        netns.device = find_network_device(each.name)
      end
    end

    def find_network_device(name)
      Link.each do |each|
        device = each.device(name)
        return device if device
      end
      nil
    end
  end
end
