require 'phut/null_logger'
require 'phut/open_vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :links

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
        fail KeyError, "key not found: #{key.inspect}"
      else
        fail "Invalid key: #{key.inspect}"
      end
    end
    # rubocop:enable MethodLength

    def find_network_device_by_name(name)
      @links.each do |each|
        device = each.find_network_device_by_name(name)
        return device if device
      end
      fail "No network device found for #{name}."
    end

    def vswitches
      @all.values.select { |each| each.is_a? OpenVswitch }
    end

    def vhosts
      @all.values.select { |each| each.is_a? Vhost }
    end

    def run
      links.each(&:run)
      vhosts.each { |each| each.run vhosts }
      vswitches.each(&:run)
    end

    def stop
      vswitches.each(&:maybe_stop)
      vhosts.each(&:maybe_stop)
      links.each(&:maybe_stop)
    end

    def add_vswitch(name, attrs)
      check_name_conflict name
      @all[name] = OpenVswitch.new(attrs[:dpid], name, @logger)
    end

    def add_vhost(name, attrs)
      check_name_conflict name
      @all[name] =
        Vhost.new(attrs[:ip], attrs[:mac], attrs[:promisc], name, @logger)
    end

    def add_link(name_a, name_b)
      @links << VirtualLink.new(name_a, name_b, @logger)
    end

    private

    def check_name_conflict(name)
      conflict = @all[name]
      fail "The name #{name} conflicts with #{conflict}." if conflict
    end
  end
end
