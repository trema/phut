require 'phut/links'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :links

    def initialize
      @vswitch = {}
      @vhost = {}
      @links = Links.new
    end

    def run
      set_switch_interfaces
      set_host_interface

      @links.run_all
      @vswitch.values.each(&:run)
      @vhost.values.each do |each|
        each.run
        each.set_ip_and_mac_address
        each.add_arp_entries @vhost.values
      end
    end

    def stop
      @vswitch.values.each(&:stop)
      @vhost.values.each(&:stop)
      @links.stop_all
    end

    private

    def set_switch_interfaces
      @vswitch.values.each do |each|
        each.interfaces = @links.find_interface_by_name(each.name)
      end
    end

    def set_host_interface
      @vhost.values.each do |each|
        interface = @links.find_interface_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        each.interface = interface.first
      end
    end
  end
end
