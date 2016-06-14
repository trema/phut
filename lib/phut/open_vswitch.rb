# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'
require 'phut/finder'
require 'phut/shell_runner'
require 'phut/vsctl'
require 'pio'

module Phut
  # Open vSwitch controller
  class OpenVswitch
    class_attribute :prefix

    extend ShellRunner
    extend Finder

    def self.name_prefix(name)
      self.prefix = name
    end

    name_prefix ''

    def self.all
      list_br.map do |name, dpid|
        tcp_port = Vsctl.new(name: name, name_prefix: prefix,
                             dpid: dpid, bridge: prefix + name).tcp_port
        if /^0x\h+/ =~ name && dpid == name.hex
          new(dpid: dpid, tcp_port: tcp_port)
        else
          new(name: name, dpid: dpid, tcp_port: tcp_port)
        end
      end
    end

    def self.list_br
      sudo('ovs-vsctl list-br').split.each_with_object([]) do |each, list|
        next unless /^#{prefix}(\S+)/ =~ each
        dpid_str = sudo("ovs-vsctl get bridge #{each} datapath-id").delete('"')
        list << [Regexp.last_match(1), ('0x' + dpid_str).hex]
      end
    end

    def self.create(*args)
      new(*args).tap(&:start)
    end

    def self.dump_flows(name)
      find_by!(name: name).dump_flows
    end

    def self.shutdown(name)
      find_by!(name: name).stop
    end

    def self.destroy_all
      all.each(&:stop)
    end

    include ShellRunner

    attr_reader :dpid
    alias datapath_id dpid
    attr_reader :tcp_port

    def initialize(dpid:, name: nil, tcp_port: 6653)
      @dpid = dpid
      @name = name
      @tcp_port = tcp_port
      @vsctl = Vsctl.new(name: default_name, name_prefix: self.class.prefix,
                         dpid: @dpid, bridge: bridge)
    end

    delegate :add_port, to: :@vsctl
    delegate :add_numbered_port, to: :@vsctl
    delegate :bring_port_up, to: :@vsctl
    delegate :bring_port_down, to: :@vsctl
    delegate :ports, to: :@vsctl
    delegate :running?, to: :@vsctl

    def name
      @name || format('%#x', @dpid)
    end
    alias default_name name

    def to_s
      "vswitch (name = #{name}, dpid = #{format('%#x', @dpid)})"
    end

    def inspect
      "#<Vswitch name: \"#{name}\", "\
      "dpid: #{@dpid.to_hex}, "\
      "openflow_version: \"#{openflow_version}\", "\
      "bridge: \"#{bridge}\">"
    end

    def start
      @vsctl.add_bridge
      @vsctl.set_openflow_version_and_dpid
      @vsctl.controller_tcp_port = @tcp_port
      @vsctl.set_fail_mode_secure
    end
    alias run start

    def stop
      raise "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      @vsctl.del_bridge
    end
    alias shutdown stop

    def openflow_version
      /OpenFlow(\d)(\d)/ =~ Pio::OpenFlow.version
      Regexp.last_match(1) + '.' + Regexp.last_match(2)
    end

    def dump_flows
      sudo("ovs-ofctl dump-flows #{bridge} -O #{Pio::OpenFlow.version}").
        split("\n").inject('') do |memo, each|
        memo + ((/^(NXST|OFPST)_FLOW reply/=~ each) ? '' : each.lstrip + "\n")
      end
    end

    def bridge
      raise 'DPID is not set' unless @dpid
      self.class.prefix + name
    end

    def <=>(other)
      dpid <=> other.dpid
    end
  end
end
