# -*- coding: utf-8 -*-

module Phuture
  # Open vSwitch controller.
  class OpenVswitch
    def initialize(dpid)
      @dpid = dpid
    end

    def run
      system "sudo #{executable} #{options.join ' '}"
      sleep 1
    end

    private

    def executable
      "#{Phuture::ROOT}/vendor/openvswitch-1.2.2.trema1/tests/test-openflowd"
    end

    def dpid_zero_filled
      no_0x = @dpid.gsub(/^0x/, '')
      '0' * (16 - no_0x.length) + no_0x
    end

    # rubocop:disable MethodLength
    def options
      %w(--detach
         --out-of-band
         --fail=closed
         --inactivity-probe=180
         --rate-limit=40000
         --burst-limit=20000
         --pidfile=/home/yasuhito/play/phuture/open_vswitch.0xabc.pid
         --verbose=ANY:file:dbg
         --verbose=ANY:console:err
         --log-file=/home/yasuhito/play/phuture/openflowd.0xabc.log
         --datapath-id=0000000000000abc
         --unixctl=/home/yasuhito/play/phuture/ovs-openflowd.0xabc.ctl
         netdev@vsw_0xabc tcp:127.0.0.1:6633)
    end
    # rubocop:enable MethodLength
  end
end
