# frozen_string_literal: true
require 'phut/shell_runner'

module Phut
  # `ip netns ...` command runner
  class Netns
    # routing table entry
    class Route
      attr_reader :net
      attr_reader :gateway

      def initialize(net:, gateway:)
        @net = net
        @gateway = gateway
      end
    end

    extend ShellRunner

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    # rubocop:disable LineLength
    def self.all
      sh('ip netns list').split("\n").map do |each|
        /^(\S+)/ =~ each
        name = Regexp.last_match(1)
        addr_list = sudo("ip -netns #{name} -4 -o addr list").split("\n")
        if addr_list.size > 1
          new(name: name,
              ip_address: Regexp.last_match(1),
              netmask: IPAddr.new('255.255.255.255').mask(Regexp.last_match(1).to_i).to_s)
        else
          new(name: name)
        end
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize
    # rubocop:enable LineLength

    def self.create(*args)
      new(*args).tap(&:run)
    end

    def self.each(&block)
      all.each(&block)
    end

    def self.find_by(queries)
      queries.inject(all) do |memo, (attr, value)|
        memo.find_all { |each| each.__send__(attr) == value }
      end.first
    end

    def self.find_by!(queries)
      find_by(queries) || raise("Netns not found: #{queries.inspect}")
    end

    def self.destroy_all
      all.each(&:stop)
    end

    include ShellRunner

    attr_reader :name
    attr_reader :ip_address

    def initialize(name:,
                   ip_address: nil, netmask: '255.255.255.255', route: {})
      @name = name
      @ip_address = ip_address
      @netmask = netmask || '255.255.255.255'
      @route = route
    end

    def run
      sudo "ip netns add #{@name}"
      netns_exec 'ifconfig lo 127.0.0.1'
    end

    # rubocop:disable LineLength
    def netmask
      if %r{inet [^/]+/(\d+) } =~ sudo("ip -netns #{@name} -o -4 address show dev #{device}")
        IPAddr.new('255.255.255.255').mask(Regexp.last_match(1).to_i).to_s
      end
    end
    # rubocop:enable LineLength

    def device
      if /^\d+: ([^@]+)@/ =~ sudo("ip -netns #{@name} -o link show type veth")
        Regexp.last_match(1)
      end
    end

    def device=(device_name)
      return unless device_name
      sudo "ip link set dev #{device_name} netns #{@name}"
      netns_exec "ifconfig #{device_name} #{@ip_address} netmask #{@netmask}"
      sleep 1
      if @route[:net] && @route[:gateway]
        netns_exec "route add -net #{@route[:net]} gw #{@route[:gateway]}"
      end
    end

    def stop
      sudo "ip netns delete #{@name}"
    end

    def route
      netns_exec('route -n').split("\n").each do |each|
        next unless /^(\S+)\s+(\S+)\s+\S+\s+UG\s+/ =~ each
        return Route.new(net: Regexp.last_match(1),
                         gateway: Regexp.last_match(2))
      end
      nil
    end

    private

    def netns_exec(command)
      sudo "ip netns exec #{@name} #{command}"
    end
  end
end
