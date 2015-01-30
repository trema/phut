require 'phut/links'
require 'phut/vswitches'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :links

    def initialize
      @vswitch = Vswitches.new
      @vhost = {}
      @links = Links.new
    end

    def run
      set_host_interface

      @links.run_all
      @vswitch.run_all(@links)
      @vhost.values.each do |each|
        each.run
        each.set_ip_and_mac_address
        each.add_arp_entries @vhost.values
      end
    end

    def stop
      @vswitch.stop_all
      @vhost.values.each(&:stop)
      @links.stop_all
    end

    private

    def set_host_interface
      @vhost.values.each do |each|
        interface = @links.find_interface_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        each.interface = interface.first
      end
    end
  end
end
