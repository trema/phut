# frozen_string_literal: true

require 'phut/shell_runner'
require 'pio'

module Phut
  # ovs-vsctl wrapper
  class Vsctl
    MAX_BRIDGE_NAME_LENGTH = 15

    extend ShellRunner

    def self.list_br(prefix)
      sudo('ovs-vsctl list-br').split.each_with_object([]) do |each, list|
        match = /^#{prefix}(\S+)/.match(each)
        next unless match
        name = match[1]
        vsctl = new(name: name, bridge: prefix + name)
        list << { name: vsctl.name,
                  dpid: vsctl.dpid,
                  openflow_version: vsctl.openflow_version,
                  tcp_port: vsctl.tcp_port }
      end
    end

    include ShellRunner

    attr_reader :name
    attr_reader :bridge

    def initialize(name:, bridge:)
      @name = name
      @bridge = bridge
    end

    def dpid
      ('0x' +
       sudo("ovs-vsctl get bridge #{@bridge} datapath-id").delete('"')).hex
    end

    def openflow_version
      case sudo("ovs-ofctl show #{@bridge} -O OpenFlow10,OpenFlow13")
      when /^OFPT_FEATURES_REPLY \(xid=0x[^\)]+\):/
        1.0
      when /^OFPT_FEATURES_REPLY \(OF(\d\.\d)\)/
        Regexp.last_match(1).to_f
      else
        raise "Couldn't identify the OpenFlow version of #{@bridge}"
      end
    end

    def add_bridge
      sudo "ovs-vsctl add-br #{@bridge}"
      sudo "/sbin/sysctl -w net.ipv6.conf.#{@bridge}.disable_ipv6=1 -q"
    end

    def delete_bridge
      sudo "ovs-vsctl del-br #{@bridge}"
    end

    def openflow_version=(version)
      sudo "ovs-vsctl set bridge #{@bridge} "\
           "protocols=OpenFlow#{version.to_s.delete('.')} "
    rescue
      raise "Invalid openflow_version: #{version}"
    end

    def dpid=(dpid)
      sudo "ovs-vsctl set bridge #{@bridge} "\
           "other-config:datapath-id=#{fill_zero(dpid)}"
    end

    def tcp_port
      controller_info = sudo("ovs-vsctl get-controller #{@bridge}")
      return if controller_info.empty?
      controller_info.chomp.split(':').last.to_i
    end

    def tcp_port=(tcp_port)
      raise "Invalid tcp_port: #{tcp_port}" if tcp_port.negative?
      sudo "ovs-vsctl set-controller #{@bridge} "\
           "tcp:127.0.0.1:#{tcp_port} "\
           "-- set controller #{@bridge} connection-mode=out-of-band"
    end

    def delete_controller
      sudo "ovs-vsctl del-controller #{@bridge}"
    end

    def set_fail_mode_secure
      sudo "ovs-vsctl set-fail-mode #{@bridge} secure"
    end

    def add_port(device)
      sudo "ovs-vsctl add-port #{@bridge} #{device}"
      nil
    end

    def add_numbered_port(port_number, device)
      add_port device
      sudo "ovs-vsctl set Interface #{device} "\
           "ofport_request=#{port_number}"
      nil
    end

    def bring_port_up(port_number)
      sh "sudo ovs-ofctl mod-port #{@bridge} #{port_number} up"
    end

    def bring_port_down(port_number)
      sh "sudo ovs-ofctl mod-port #{@bridge} #{port_number} down"
    end

    def ports
      sudo("ovs-vsctl list-ports #{@bridge}").split
    end

    private

    def fill_zero(dpid)
      hex = format('%x', dpid)
      '0' * (16 - hex.length) + hex
    end
  end
end
