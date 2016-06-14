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
    extend ShellRunner
    extend Finder

    class_attribute :prefix
    self.prefix = ''

    def self.create(*args)
      found = find_by(dpid: args.first[:dpid])
      if found
        inspection = "name: \"#{found.name}\", dpid: #{found.dpid.to_hex}"
        raise "a Vswitch (#{inspection}) already exists"
      end
      new(*args).__send__ :start
    end

    def self.destroy(name)
      find_by!(name: name).destroy
    end

    def self.destroy_all
      all.each(&:destroy)
    end

    def self.all
      Vsctl.list_br(prefix).map do |name, dpid|
        tcp_port = Vsctl.new(name: name, name_prefix: prefix,
                             dpid: dpid, bridge: prefix + name).tcp_port
        if /^0x\h+/ =~ name && dpid == name.hex
          new(dpid: dpid, tcp_port: tcp_port)
        else
          new(name: name, dpid: dpid, tcp_port: tcp_port)
        end
      end
    end

    def self.dump_flows(name)
      find_by!(name: name).dump_flows
    end

    def self.name_prefix(name)
      self.prefix = name
    end

    include ShellRunner

    attr_reader :dpid
    alias datapath_id dpid
    attr_reader :tcp_port

    private_class_method :new

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

    def destroy
      raise "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      @vsctl.del_bridge
    end

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

    private

    def start
      @vsctl.add_bridge
      @vsctl.set_openflow_version_and_dpid
      @vsctl.controller_tcp_port = @tcp_port
      @vsctl.set_fail_mode_secure
      self
    end
  end
end
