# frozen_string_literal: true
require 'phut/shell_runner'
require 'pio'

module Phut
  # ovs-vsctl wrapper
  class Vsctl
    extend ShellRunner

    def self.list_br(prefix)
      sudo('ovs-vsctl list-br').split.each_with_object([]) do |each, list|
        next unless /^#{prefix}(\S+)/ =~ each
        dpid_str = sudo("ovs-vsctl get bridge #{each} datapath-id").delete('"')
        list << [Regexp.last_match(1), ('0x' + dpid_str).hex]
      end
    end

    include ShellRunner

    def initialize(name:, name_prefix:, dpid:, bridge:)
      @name = name
      @prefix = name_prefix
      @dpid = dpid
      @bridge = bridge
    end

    def tcp_port
      sudo("ovs-vsctl get-controller #{@bridge}").
        chomp.split(':').last.to_i
    end

    def add_bridge
      sudo "ovs-vsctl add-br #{@bridge}"
      sudo "/sbin/sysctl -w net.ipv6.conf.#{@bridge}.disable_ipv6=1 -q"
    end

    def del_bridge
      sudo "ovs-vsctl del-br #{@bridge}"
    end

    def set_openflow_version_and_dpid
      sudo "ovs-vsctl set bridge #{@bridge} "\
           "protocols=#{Pio::OpenFlow.version} "\
           "other-config:datapath-id=#{dpid_zero_filled}"
    end

    def controller_tcp_port=(tcp_port)
      sudo "ovs-vsctl set-controller #{@bridge} "\
           "tcp:127.0.0.1:#{tcp_port} "\
           "-- set controller #{@bridge} connection-mode=out-of-band"
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
      sudo "ovs-vsctl set Port #{device} "\
           "other_config:rstp-port-num=#{port_number}"
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

    def running?
      system("sudo ovs-vsctl br-exists #{@bridge}") &&
        !sudo("ovs-vsctl get-controller #{@bridge}").empty?
    end

    private

    def dpid_zero_filled
      raise 'DPID is not set' unless @dpid
      hex = format('%x', @dpid)
      '0' * (16 - hex.length) + hex
    end
  end
end
