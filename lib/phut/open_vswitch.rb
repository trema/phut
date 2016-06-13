# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation.rb'
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
        if /^0x\h+/ =~ name
          new(dpid: dpid) if dpid == name.hex
        else
          new(name: name, dpid: dpid)
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

    def self.select(&block)
      all.select(&block)
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

    def initialize(dpid:, name: nil, tcp_port: 6653)
      @dpid = dpid
      @name = name
      @tcp_port = tcp_port
      @vsctl = Vsctl.new(name: default_name, name_prefix: self.class.prefix,
                         dpid: @dpid, bridge_name: bridge_name)
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

    def dump_flows
      sudo("ovs-ofctl dump-flows #{bridge_name} -O #{Pio::OpenFlow.version}").
        split("\n").inject('') do |memo, each|
        memo + ((/^(NXST|OFPST)_FLOW reply/=~ each) ? '' : each.lstrip + "\n")
      end
    end

    def <=>(other)
      dpid <=> other.dpid
    end

    private

    def bridge_name
      raise 'DPID is not set' unless @dpid
      self.class.prefix + name
    end
  end
end
