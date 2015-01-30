module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :link

    def initialize
      @vswitch = {}
      @vhost = {}
      @link = []
    end

    def run
      set_switch_interfaces
      set_host_interface

      @link.each(&:run)
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
      @link.each(&:stop)
    end

    def find_link(peer_a, peer_b)
      @link.select do |each|
        each.peer_a == peer_a && each.peer_b == peer_b
      end[0]
    end

    private

    def set_switch_interfaces
      @vswitch.values.each do |each|
        each.interfaces = find_interface_by_name(each.name)
      end
    end

    def set_host_interface
      @vhost.values.each do |each|
        interface = find_interface_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        each.interface = interface.first
      end
    end

    def find_interface_by_name(name)
      @link.each_with_object([]) do |each, list|
        list << each.name_a if name == each.peer_a
        list << each.name_b if name == each.peer_b
      end
    end
  end
end
