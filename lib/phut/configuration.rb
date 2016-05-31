# frozen_string_literal: true
require 'phut/vhost'
require 'phut/vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    def initialize
      Vswitch.destroy_all
      Vhost.destroy_all
      Netns.all.clear
      Link.destroy_all
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
        Link.each do |each|
          return each if each.names == key.sort.map(&:to_sym)
        end
        raise "link #{key.sort.join(' <-> ')} not found."
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
      Netns.each(&:run)
    end

    def stop
      [Vswitch, Vhost, Netns, Link].each do |klass|
        klass.each(&:stop)
      end
    end

    private

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
      Netns.each do |each|
        each.network_device = find_network_device(each)
      end
    end

    def find_network_device(vhost)
      Link.each do |each|
        device = each.device(vhost.name)
        return device if device
      end
      raise "No network device found for #{vhost}."
    end
  end
end
