require 'rake'

module Phut
  # Open vSwitch controller.
  class OpenVswitch
    include FileUtils

    OPENFLOWD =
      "#{Phut::ROOT}/vendor/openvswitch-1.2.2.trema1/tests/test-openflowd"
    OFCTL =
      "#{Phut::ROOT}/vendor/openvswitch-1.2.2.trema1/utilities/ovs-ofctl"

    attr_reader :dpid
    alias_method :datapath_id, :dpid
    attr_reader :name
    attr_writer :interfaces

    def initialize(dpid, name = nil)
      @dpid = dpid
      @name = name || @dpid
      @interfaces = []
    end

    def run
      fail "Open vSwitch (dpid = #{@dpid}) is already running!" if running?
      sh "sudo #{OPENFLOWD} #{options.join ' '}", verbose: false
      loop { break if running? }
    end
    alias_method :start, :run

    def stop
      fail "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      pid = IO.read(pid_file).chomp
      sh "sudo kill #{pid}", verbose: false
      loop { break unless running? }
    end
    alias_method :shutdown, :stop

    def dump_flows
      sh "sudo #{OFCTL} dump-flows #{network_device}", verbose: false
    end

    private

    def restart
      stop
      start
    end

    def running?
      FileTest.exists?(pid_file)
    end

    def pid_file
      "#{Phut.settings['PID_DIR']}/open_vswitch.#{name}.pid"
    end

    def network_device
      "vsw_#{@dpid}"
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
         --log-file=#{Phut.settings['LOG_DIR']}/open_vswitch.#{name}.log
         --datapath-id=#{dpid_zero_filled}
         --unixctl=#{Phut.settings['SOCKET_DIR']}/open_vswitch.#{name}.ctl
         netdev@#{network_device} tcp:127.0.0.1:6633) +
        (@interfaces.empty? ? [] : ["--ports=#{@interfaces.join(',')}"])
    end
    # rubocop:enable MethodLength

    def dpid_zero_filled
      no_0x = @dpid.to_s.gsub(/^0x/, '')
      '0' * (16 - no_0x.length) + no_0x
    end
  end
end
