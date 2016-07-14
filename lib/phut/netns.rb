# frozen_string_literal: true
require 'phut/finder'
require 'phut/route'
require 'phut/shell_runner'

module Phut
  # `ip netns ...` command runner
  class Netns
    extend ShellRunner
    extend Finder

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def self.all
      sh('ip netns list').split("\n").map do |each|
        name = each.split.first
        addr_list = sudo("ip -netns #{name} -4 -o addr list").split("\n")
        if addr_list.size > 1
          %r{inet ([^/]+)/(\d+)} =~ addr_list[1]
          new(name: name,
              ip_address: Regexp.last_match(1),
              netmask: IPAddr.new('255.255.255.255').
                       mask(Regexp.last_match(2).to_i).to_s)
        else
          new(name: name)
        end
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize

    def self.create(*args)
      new(*args).tap(&:run)
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
      @netmask = netmask
      @route = Route.new(net: route[:net], gateway: route[:gateway])
    end

    def run
      sudo "ip netns add #{@name}"
      sudo "ip netns exec #{@name} ifconfig lo 127.0.0.1"
    end

    def netmask
      if %r{inet [^/]+/(\d+) } =~
         sudo("ip -netns #{@name} -o -4 address show dev #{device}")
        IPAddr.new('255.255.255.255').mask(Regexp.last_match(1).to_i).to_s
      end
    end

    def device
      if /^\d+: ([^@]+)@/ =~ sudo("ip -netns #{@name} -o link show type veth")
        Regexp.last_match(1)
      end
    end

    def mac_address
      if %r{link/ether (\S+)}=~ sudo("ip netns exec #{name} ip -o link show")
        Regexp.last_match(1)
      end
    end

    def device=(device_name)
      return unless device_name
      sudo "ip link set dev #{device_name} netns #{@name}"
      sudo "ip netns exec #{@name} "\
           "ifconfig #{device_name} #{@ip_address} netmask #{@netmask}"
      @route.add @name
    end

    def stop
      sudo "ip netns delete #{@name}"
    end

    def route
      Route.read @name
    end
  end
end
