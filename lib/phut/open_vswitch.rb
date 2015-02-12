require 'phut/settings'
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
      @name = name || format('%#x', @dpid)
      @interfaces = []
    end

    def run
      fail "Open vSwitch (dpid = #{@dpid}) is already running!" if running?
      sh "sudo #{OPENFLOWD} #{options.join ' '}",
         verbose: Phut.settings[:verbose]
      loop { break if running? }
    end
    alias_method :start, :run

    def stop
      fail "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      pid = IO.read(pid_file).chomp
      sh "sudo kill #{pid}", verbose: Phut.settings[:verbose]
      loop { break unless running? }
    end
    alias_method :shutdown, :stop

    def bring_port_up(port_number)
      sh "sudo #{OFCTL} mod-port #{network_device} #{port_number} up",
         verbose: Phut.settings[:verbose]
    end

    def bring_port_down(port_number)
      sh "sudo #{OFCTL} mod-port #{network_device} #{port_number} down",
         verbose: Phut.settings[:verbose]
    end

    def dump_flows
      sh "sudo #{OFCTL} dump-flows #{network_device}",
         verbose: Phut.settings[:verbose]
    end

    def running?
      FileTest.exists?(pid_file)
    end

    private

    def restart
      stop
      start
    end

    def pid_file
      "#{Phut.settings[:pid_dir]}/open_vswitch.#{name}.pid"
    end

    def network_device
      "vsw_#{name}"
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
         --log-file=#{Phut.settings[:log_dir]}/open_vswitch.#{name}.log
         --datapath-id=#{dpid_zero_filled}
         --unixctl=#{Phut.settings[:socket_dir]}/open_vswitch.#{name}.ctl
         netdev@#{network_device} tcp:127.0.0.1:6633) +
        (@interfaces.empty? ? [] : ["--ports=#{@interfaces.join(',')}"])
    end
    # rubocop:enable MethodLength

    def dpid_zero_filled
      hex = format('%x', @dpid)
      '0' * (16 - hex.length) + hex
    end
  end
end
