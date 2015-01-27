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

    def find_interface(host_name)
      @link.each do |each|
        return each.name_a if host_name == each.peer_a
        return each.name_b if host_name == each.peer_b
      end
      fail "No link found for host #{host_name}"
    end

    def find_interfaces(switch_name)
      @link.reduce([]) do |result, each|
        result << each.name_a if switch_name == each.peer_a
        result << each.name_b if switch_name == each.peer_b
        result
      end
    end

    def find_link(peer_a, peer_b)
      @link.select do |each|
        each.peer_a == peer_a && each.peer_b == peer_b
      end[0]
    end
  end
end
