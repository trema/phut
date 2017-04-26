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
        ip_addr_list =
          sudo("ip netns exec #{name} ip -4 -o addr list").split("\n")
        mac_addr_list =
          sudo("ip netns exec #{name} ip -4 -o link list").split("\n")
        if ip_addr_list.size > 1
          %r{inet ([^/]+)/(\d+)} =~ ip_addr_list[1]
          ip_address = Regexp.last_match(1)
          mask_length = Regexp.last_match(2).to_i
          netmask = IPAddr.new('255.255.255.255').mask(mask_length).to_s
          %r{link/ether ((?:[a-f\d]{2}:){5}[a-f\d]{2})}i =~ mac_addr_list[1]
          new(name: name, ip_address: ip_address, netmask: netmask,
              mac_address: Regexp.last_match(1))
        else
          new(name: name)
        end
      end.sort_by(&:name)
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
    attr_reader :mac_address

    # rubocop:disable ParameterLists
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
    # rubocop:enable MethodLength
    # rubocop:enable ParameterLists

    def run
      sudo "ip netns add #{name}"
      sudo "ip netns exec #{name} ifconfig lo 127.0.0.1"
    end

    def stop
      sudo("ip netns pids #{name}").split("\n").each do |each|
        exec "kill #{each}"
      end
      sudo "ip netns delete #{name}"
    end

    def exec(command)
      sudo "ip netns exec #{name} #{command}"
    end

    def device
      return unless /^\d+: #{Veth::PREFIX}(\d+)_([^:\.]*?)[@:]/ =~
                    sudo("ip netns exec #{name} ip -o link show")
      Veth.new(name: $LAST_MATCH_INFO[2], link_id: $LAST_MATCH_INFO[1].to_i)
    end

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def device=(veth)
      sudo "ip link set dev #{veth} netns #{name}"

      vlan_suffix = @vlan ? ".#{@vlan}" : ''
      if @vlan
        sudo "ip netns exec #{name} ip link set #{veth} up"
        sudo "ip netns exec #{name} "\
             "ip link add link #{veth} name "\
             "#{veth}#{vlan_suffix} type vlan id #{@vlan}"
      end
      if @mac_address
        sudo "ip netns exec #{name} "\
             "ip link set #{veth}#{vlan_suffix} address #{@mac_address}"
      end
      sudo "ip netns exec #{name} ip link set #{veth}#{vlan_suffix} up"
      sudo "ip netns exec #{name} "\
           "ip addr replace #{@ip_address}/#{@netmask} "\
           "dev #{veth}#{vlan_suffix}"
      sudo "ip netns exec #{name} ip link set #{veth}#{vlan_suffix} up"

      @route.add name
    end
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize

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
      if /^\d+: #{device.device}\.(\d+)@/ =~
         sudo("ip netns exec #{name} ip -o link show")
        Regexp.last_match(1)
      end
    end
  end
end
