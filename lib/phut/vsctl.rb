# frozen_string_literal: true
require 'phut/shell_runner'
require 'pio'

module Phut
  # ovs-vsctl wrapper
  class Vsctl
    include ShellRunner

    def initialize(name:, name_prefix:, dpid:, bridge_name:)
      @name = name
      @prefix = name_prefix
      @dpid = dpid
      @bridge_name = bridge_name
    end

    def tcp_port
      sudo("ovs-vsctl get-controller #{@bridge_name}").
        chomp.split(':').last.to_i
    end

    def add_bridge
      sudo "ovs-vsctl add-br #{@bridge_name}"
      sudo "/sbin/sysctl -w net.ipv6.conf.#{@bridge_name}.disable_ipv6=1 -q"
    end

    def del_bridge
      sudo "ovs-vsctl del-br #{@bridge_name}"
    end

    def set_openflow_version_and_dpid
      sudo "ovs-vsctl set bridge #{@bridge_name} "\
           "protocols=#{Pio::OpenFlow.version} "\
           "other-config:datapath-id=#{dpid_zero_filled}"
    end

    def controller_tcp_port=(tcp_port)
      sudo "ovs-vsctl set-controller #{@bridge_name} "\
           "tcp:127.0.0.1:#{tcp_port} "\
           "-- set controller #{@bridge_name} connection-mode=out-of-band"
    end

    def set_fail_mode_secure
      sudo "ovs-vsctl set-fail-mode #{@bridge_name} secure"
    end

    def add_port(device)
      sudo "ovs-vsctl add-port #{@bridge_name} #{device}"
    end

    def add_numbered_port(port_number, device)
      add_port device
      sudo "ovs-vsctl set Port #{device} "\
           "other_config:rstp-port-num=#{port_number}"
    end

    def bring_port_up(port_number)
      sh "sudo ovs-ofctl mod-port #{@bridge_name} #{port_number} up"
    end

    def bring_port_down(port_number)
      sh "sudo ovs-ofctl mod-port #{@bridge_name} #{port_number} down"
    end

    def ports
      sudo("ovs-vsctl list-ports #{@bridge_name}").split
    end

    def running?
      system("sudo ovs-vsctl br-exists #{@bridge_name}") &&
        !sudo("ovs-vsctl get-controller #{@bridge_name}").empty?
    end

    private

    def dpid_zero_filled
      raise 'DPID is not set' unless @dpid
      hex = format('%x', @dpid)
      '0' * (16 - hex.length) + hex
    end
  end
end
