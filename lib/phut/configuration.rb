require 'phut/links'
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
      @links = Links.new
      @logger = logger
    end

    def run
      @links.run_all
      @vswitch.run_all
      @vhost.run_all(@links)
    end

    def stop
      @vswitch.stop_all
      @vhost.stop_all
      @links.stop_all
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

    def set_host_and_switch_interfaces
      @vswitch.values.each do |each|
        each.interfaces = @links.find_interfaces_by_name(each.name)
      end
    end
  end
end
