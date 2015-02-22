require 'phut/null_logger'
require 'phut/open_vswitch'
require 'phut/vhosts'
require 'phut/vswitches'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :links

    def initialize(logger = NullLogger.new)
      @vswitch = Vswitches.new
      @vhost = Vhosts.new
      @links = []
      @logger = logger
    end

    def run
      @links.map(&:run)
      @vswitch.run_all
      @vhost.run_all
    end

    def stop
      @vswitch.stop_all
      @vhost.stop_all
      @links.map(&:stop)
    end

    def add_vswitch(name, attrs)
      @vswitch[name] = OpenVswitch.new(attrs[:dpid], name, @logger)
    end

    def add_vhost(name, attrs)
      @vhost[name] = Phost.new(attrs[:ip], attrs[:promisc], name, @logger)
    end

    def next_link_id
      @links.size
    end

    def add_link(name_a, device_a, name_b, device_b)
      @links << VirtualLink.new(name_a, device_a, name_b, device_b, @logger)
    end

    def set_vswitch_interfaces
      @vswitch.values.each do |each|
        each.interfaces = find_interfaces_by_name(each.name)
      end
    end

    def set_vhost_interface
      @vhost.values.each do |each|
        interface = find_interfaces_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        if interface.size > 1
          fail "Multiple links are connected to host #{each.name}"
        end
        each.interface = interface.first
      end
    end

    def find_interfaces_by_name(name)
      interfaces = @links.select { |each| each.name_a == name }.map(&:device_a)
      interfaces + @links.select { |each| each.name_b == name }.map(&:device_b)
    end
  end
end
