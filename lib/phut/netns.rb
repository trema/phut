# frozen_string_literal: true
require 'phut/finder'
require 'phut/route'
require 'phut/shell_runner'
require 'phut/veth'

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
        addr_list = sudo("ip netns exec #{name} ip -4 -o addr list").split("\n")
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
                   ip_address: nil,
                   mac_address: nil,
                   netmask: '255.255.255.255',
                   route: {},
                   vlan: nil)
      @name = name
      @ip_address = ip_address
      @mac_address = mac_address
      @netmask = netmask
      @route = Route.new(net: route[:net], gateway: route[:gateway])
      @vlan = vlan
    end

    def run
      sudo "ip netns add #{name}"
      sudo "ip netns exec #{name} ifconfig lo 127.0.0.1"
    end

    def stop
      sudo "ip netns delete #{name}"
    end

    def exec(command)
      sudo "ip netns exec #{name} #{command}"
    end

    def device
      if /^\d+: (#{Phut::Veth::PREFIX}[^:\.]*?)[:@]/ =~
         sudo("ip netns exec #{name} ip -o link show")
        Regexp.last_match(1)
      end
    end

    # rubocop:disable MethodLength
    def device=(device_name)
      return unless device_name
      sudo "ip link set dev #{device_name} netns #{name}"

      vlan_suffix = @vlan ? ".#{@vlan}" : ''
      if @vlan
        sudo "ip netns exec #{name} ip link set #{device_name} up"
        sudo "ip netns exec #{name} "\
             "ip link add link #{device_name} name "\
             "#{device_name}#{vlan_suffix} type vlan id #{@vlan}"
      end
      if @mac_address
        sudo "ip netns exec #{name} "\
             "ip link set #{device_name}#{vlan_suffix} address #{@mac_address}"
      end
      sudo "ip netns exec #{name} ip link set #{device_name}#{vlan_suffix} up"
      sudo "ip netns exec #{name} "\
           "ip addr replace #{@ip_address}/#{@netmask} "\
           "dev #{device_name}#{vlan_suffix}"

      sudo "ip netns exec #{name} ip link set #{device_name}#{vlan_suffix} up"

      @route.add name
    end
    # rubocop:enable MethodLength

    def netmask
      if %r{inet [^/]+/(\d+) } =~
         sudo("ip netns exec #{name} ip -o -4 address show dev #{device}")
        IPAddr.new('255.255.255.255').mask(Regexp.last_match(1).to_i).to_s
      end
    end

    def route
      Route.read name
    end

    def vlan
      if /^\d+: #{device}\.(\d+)@/ =~
         sudo("ip netns exec #{name} ip -o link show")
        Regexp.last_match(1)
      end
    end
  end
end
