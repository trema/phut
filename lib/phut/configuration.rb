require 'phut/null_logger'
require 'phut/open_vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    def initialize(logger = NullLogger.new)
      @all = {}
      @links = []
      @logger = logger
    end

    # rubocop:disable MethodLength
    def fetch(key)
      case key
      when String
        @all.fetch(key)
      when Array
        @links.each do |each|
          return each if [each.name_a, each.name_b].sort == key.sort
        end
        fail "link #{key.join ' '} not found."
      else
        fail "Invalid key: #{key.inspect}"
      end
    end
    # rubocop:enable MethodLength

    def update_connections
      update_vswitch_ports
      update_vhost_interfaces
      update_netns_interfaces
      self
    end

    def vswitches
      @all.values.select { |each| each.is_a? OpenVswitch }
    end

    def vhosts
      @all.values.select { |each| each.is_a? Vhost }
    end

    def netnss
      @all.values.select { |each| each.is_a? Netns }
    end

    def run
      @links.each(&:run)
      vhosts.each { |each| each.run vhosts }
      netnss.each(&:run)
      vswitches.each(&:run)
    end

    def stop
      vswitches.each(&:maybe_stop)
      vhosts.each(&:maybe_stop)
      netnss.each(&:maybe_stop)
      @links.each(&:maybe_stop)
    end

    def add_vswitch(name, attrs)
      check_name_conflict name
      @all[name] =
        OpenVswitch.new(attrs[:dpid], attrs[:port_number], name, @logger)
    end

    def add_vhost(name, attrs)
      check_name_conflict name
      @all[name] =
        Vhost.new(attrs[:ip], attrs[:mac], attrs[:promisc], name, @logger)
    end

    def add_netns(name, attrs)
      check_name_conflict name
      @all[name] = Netns.new(attrs, name, @logger)
    end

    def add_link(name_a, name_b)
      @links << VirtualLink.new(name_a, name_b, @logger)
    end

    private

    def check_name_conflict(name)
      conflict = @all[name]
      fail "The name #{name} conflicts with #{conflict}." if conflict
    end

    def update_vswitch_ports
      @links.each do |each|
        maybe_connect_link_to_vswitch each
      end
    end

    def maybe_connect_link_to_vswitch(link)
      vswitches_connected_to(link).each do |each|
        each.add_network_device link.find_network_device(each)
      end
    end

    def vswitches_connected_to(link)
      vswitches.select { |each| link.connect_to?(each) }
    end

    def update_vhost_interfaces
      vhosts.each do |each|
        each.network_device = find_network_device(each)
      end
    end

    def update_netns_interfaces
      netnss.each do |each|
        each.network_device = find_network_device(each)
      end
    end

    def find_network_device(vhost)
      @links.each do |each|
        device = each.find_network_device(vhost)
        return device if device
      end
      fail "No network device found for #{vhost}."
    end
  end
end
