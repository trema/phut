# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'
require 'phut/finder'
require 'phut/link'
require 'phut/shell_runner'
require 'phut/vsctl'
require 'pio'

module Phut
  # Open vSwitch controller
  # rubocop:disable ClassLength
  class OpenVswitch
    extend ShellRunner
    extend Finder

    class_attribute :bridge_prefix
    self.bridge_prefix = ''

    def self.create(args)
      found = find_by(name: args[:name]) || find_by(dpid: args[:dpid])
      raise "a Vswitch #{found.inspect} already exists" if found
      new(args).__send__ :start
    end

    def self.destroy(name)
      find_by!(name: name).destroy
    end

    def self.destroy_all
      all.each(&:destroy)
    end

    def self.all
      Vsctl.list_br(bridge_prefix).map do |bridge_attrs|
        new(bridge_attrs)
      end.sort_by(&:dpid)
    end

    def self.select(&block)
      all.select(&block)
    end

    def self.dump_flows(name)
      find_by!(name: name).dump_flows
    end

    include ShellRunner

    private_class_method :new

    def initialize(dpid:, openflow_version: 1.0, name: nil, tcp_port: 6653)
      @dpid = dpid
      @name = name
      @openflow_version = openflow_version
      @tcp_port = tcp_port
      @vsctl = Vsctl.new(name: default_name, bridge: default_bridge)
    end

    def to_s
      "vswitch (name = #{name}, dpid = #{format('%#x', @dpid)})"
    end

    def inspect
      "#<Vswitch name: \"#{name}\", "\
      "dpid: #{@dpid.to_hex}, "\
      "openflow_version: #{openflow_version}, "\
      "tcp_port: #{tcp_port}>"
    end

    def name
      /^#{bridge_prefix}(\S+)$/ =~ bridge
      Regexp.last_match(1)
    end

    delegate :bridge_prefix, to: 'self.class'
    delegate :bridge, to: :@vsctl
    delegate :dpid, to: :@vsctl
    alias datapath_id dpid
    delegate :openflow_version, to: :@vsctl
    delegate :tcp_port, to: :@vsctl

    delegate :add_numbered_port, to: :@vsctl
    delegate :add_port, to: :@vsctl
    delegate :bring_port_down, to: :@vsctl
    delegate :bring_port_up, to: :@vsctl
    delegate :ports, to: :@vsctl
    delegate :delete_bridge, to: :@vsctl
    alias destroy delete_bridge
    delegate :delete_controller, to: :@vsctl
    alias stop delete_controller

    def run(port)
      raise "An Open vSwitch #{inspect} is already running" if @vsctl.tcp_port
      @vsctl.tcp_port = port
    end

    # rubocop:disable MethodLength
    # rubocop:disable LineLength
    def dump_flows
      openflow_version = case @vsctl.openflow_version
                         when 1.0
                           :OpenFlow10
                         when 1.3
                           :OpenFlow13
                         else
                           raise "Unknown OpenFlow version: #{@vsctl.openflow_version}"
                         end
      sudo("ovs-ofctl dump-flows #{bridge} -O #{openflow_version}").
        split("\n").inject('') do |memo, each|
        memo + (/^(NXST|OFPST)_FLOW reply/=~ each ? '' : each.lstrip + "\n")
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable LineLength

    def <=>(other)
      dpid <=> other.dpid
    end

    private

    # rubocop:disable LineLength
    def default_name
      if @name
        if (bridge_prefix + @name).length > Vsctl::MAX_BRIDGE_NAME_LENGTH
          raise "Name '#{@name}' is too long (should be <= #{Vsctl::MAX_BRIDGE_NAME_LENGTH - bridge_prefix.length} chars)"
        end
        return @name
      end
      raise 'DPID is not set' unless @dpid
      format('%#x', @dpid)
    end
    # rubocop:enable LineLength

    def default_bridge
      bridge_prefix + default_name
    end

    def start
      @vsctl.add_bridge
      @vsctl.openflow_version = @openflow_version
      @vsctl.dpid = @dpid
      @vsctl.tcp_port = @tcp_port
      @vsctl.set_fail_mode_secure
      self
    end
  end
  # rubocop:enable ClassLength
end
