# frozen_string_literal: true
require 'phut/null_logger'
require 'phut/vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    def initialize
      Vswitch.all.clear
      Vhost.all.clear
      Netns.all.clear
      VirtualLink.all.clear
      yield self
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
        VirtualLink.each do |each|
          return each if [each.name_a, each.name_b].sort == key.sort
        end
        raise "link #{key.join ' '} not found."
      else
        raise "Invalid key: #{key.inspect}"
      end
    end
    # rubocop:enable MethodLength

    def update_connections
      update_vswitch_ports
      update_vhost_interfaces
      update_netns_interfaces
      self
    end

    def run
      [VirtualLink, Vhost, Netns].each do |klass|
        klass.each(&:run)
      end
    end

    def stop
      [Vswitch, Vhost, Netns, VirtualLink].each do |klass|
        klass.each(&:stop)
      end
    end

    private

    def update_vswitch_ports
      VirtualLink.each do |each|
        maybe_connect_link_to_vswitch each
      end
    end

    def maybe_connect_link_to_vswitch(link)
      vswitches_connected_to(link).each do |each|
        each.add_port link.find_network_device(each).name
      end
    end

    def vswitches_connected_to(link)
      Vswitch.select { |each| link.connect_to?(each) }
    end

    def update_vhost_interfaces
      Vhost.each do |each|
        each.network_device = find_network_device(each)
      end
    end

    def update_netns_interfaces
      Netns.each do |each|
        each.network_device = find_network_device(each)
      end
    end

    def find_network_device(vhost)
      VirtualLink.each do |each|
        device = each.find_network_device(vhost)
        return device if device
      end
      raise "No network device found for #{vhost}."
    end
  end
end
