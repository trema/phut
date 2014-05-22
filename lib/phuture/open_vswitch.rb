# -*- coding: utf-8 -*-
require 'phuture/settings'

module Phuture
  # Open vSwitch controller.
  class OpenVswitch
    attr_reader :dpid

    def initialize(dpid)
      @dpid = dpid
    end

    def run
      system "sudo #{executable} #{options.join ' '}"
      sleep 1
    end

    def stop
      pid = IO.read(pid_file)
      system "sudo kill #{pid}"
    end

    private

    def pid_file
      "#{Phuture.settings['PID_DIR']}/open_vswitch.#{@dpid}.pid"
    end

    def executable
      "#{Phuture::ROOT}/vendor/openvswitch-1.2.2.trema1/tests/test-openflowd"
    end

    # rubocop:disable MethodLength
    def options
      %W(--detach
         --out-of-band
         --fail=closed
         --inactivity-probe=180
         --rate-limit=40000
         --burst-limit=20000
         --pidfile=#{pid_file}
         --verbose=ANY:file:dbg
         --verbose=ANY:console:err
         --log-file=#{Phuture.settings['LOG_DIR']}/openflowd.#{@dpid}.log
         --datapath-id=#{dpid_zero_filled}
         --unixctl=#{Phuture.settings['SOCKET_DIR']}/ovs-openflowd.#{@dpid}.ctl
         netdev@vsw_#{@dpid} tcp:127.0.0.1:6633)
    end
    # rubocop:enable MethodLength

    def dpid_zero_filled
      no_0x = @dpid.gsub(/^0x/, '')
      '0' * (16 - no_0x.length) + no_0x
    end
  end
end
