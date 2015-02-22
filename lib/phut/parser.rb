require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(logger = NullLogger.new)
      @config = Configuration.new(logger)
    end

    def parse(file)
      Syntax.new(@config).instance_eval IO.read(file), file
      assign_vswitch_interfaces
      assign_vhost_interface
      @config
    end

    private

    def assign_vswitch_interfaces
      @config.vswitches.each do |each|
        each.interfaces = find_interfaces_by_name(each.name)
      end
    end

    def assign_vhost_interface
      @config.vhosts.each do |each|
        each.interface = find_host_interface_by_name(each.name)
      end
    end

    def find_interfaces_by_name(name)
      find_device_by_name(name, :name_a, :device_a) +
        find_device_by_name(name, :name_b, :device_b)
    end

    def find_host_interface_by_name(name)
      find_interfaces_by_name(name).tap do |interface|
        fail "No link found for host #{name}" if interface.empty?
        fail "Multiple links connect to host #{name}" if interface.size > 1
      end.first
    end

    def find_device_by_name(name, name_type, device_type)
      @config.links.select do |each|
        each.__send__(name_type) == name
      end.map(&device_type)
    end
  end
end
