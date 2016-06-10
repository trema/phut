# frozen_string_literal: true
require 'phut/vhost'
require 'phut/vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :netns

    def initialize
      @netns = []
      yield self
      update_connections
    end

    # rubocop:disable MethodLength
    def fetch(key)
      case key
      when String
        [Vswitch, Vhost, Netns].each do |each|
          found = each.find_by(name: key)
          return found if found
        end
        raise "Invalid key: #{key.inspect}"
      when Array
        Link.each do |each|
          return each if each.names == key.sort.map(&:to_sym)
        end
        raise "link #{key.sort.join(' <-> ')} not found."
      else
        raise "Invalid key: #{key.inspect}"
      end
    end
    # rubocop:enable MethodLength

    def stop
      [Vswitch, Vhost, Netns, Link].each do |klass|
        klass.each(&:stop)
      end
    end

    private

    def update_connections
      update_vswitch_ports
      update_vhost_interfaces
      update_netns_interfaces
    end

    def update_vswitch_ports
      Link.each do |each|
        maybe_connect_link_to_vswitch each
      end
    end

    def maybe_connect_link_to_vswitch(link)
      vswitches_connected_to(link).each do |each|
        each.add_port link.device(each.name)
      end
    end

    def vswitches_connected_to(link)
      Vswitch.select { |each| link.connect_to?(each) }
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
