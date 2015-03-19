require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(logger = NullLogger.new)
      @config = Configuration.new(logger)
      @port_number = Hash.new(0)
    end

    def parse(file)
      Syntax.new(@config).instance_eval IO.read(file), file
      connect_links_to_switches
      connect_links_to_vhosts
      @config
    end

    private

    def connect_links_to_switches
      @config.links.each do |each|
        maybe_assign_network_device_to_vswitch each
      end
    end

    def connect_links_to_vhosts
      @config.vhosts.each do |each|
        each.network_device = @config.find_network_device_by_name(each.name)
      end
    end

    def maybe_assign_network_device_to_vswitch(link)
      @config.vswitches.each do |each|
        switch_name = each.name
        network_device = link.find_network_device_by_name(switch_name)
        next unless network_device
        network_device.port_number = new_port_number(switch_name)
        each.network_devices << network_device
      end
    end

    def new_port_number(switch_name)
      @port_number[switch_name] += 1
    end
  end
end
