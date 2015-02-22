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
      set_vswitch_interfaces
      set_vhost_interface
      @config
    end

    private

    def set_vswitch_interfaces
      @config.vswitches.each do |each|
        each.interfaces = find_interfaces_by_name(each.name)
      end
    end

    def set_vhost_interface
      @config.vhosts.each do |each|
        interface = find_interfaces_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        if interface.size > 1
          fail "Multiple links are connected to host #{each.name}"
        end
        each.interface = interface.first
      end
    end

    def find_interfaces_by_name(name)
      @config.links.select { |each| each.name_a == name }.map(&:device_a) +
        @config.links.select { |each| each.name_b == name }.map(&:device_b)
    end
  end
end
