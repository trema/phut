require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'

module Phut
  # Open vSwitch controller.
  class OpenVswitch
    include ShellRunner

    OPENFLOWD =
      "#{Phut.root}/vendor/openvswitch-1.2.2.trema1/tests/test-openflowd"
    OFCTL =
      "#{Phut.root}/vendor/openvswitch-1.2.2.trema1/utilities/ovs-ofctl"

    attr_reader :dpid
    alias_method :datapath_id, :dpid
    attr_writer :interfaces

    def initialize(dpid, name = nil, logger = NullLogger.new)
      @dpid = dpid
      @name = name
      @interfaces = []
      @logger = logger
    end

    def name
      @name || format('%#x', @dpid)
    end

    def to_s
      "vswitch (name = #{name}, dpid = #{format('%#x', @dpid)})"
    end

    def run
      sh "sudo #{OPENFLOWD} #{options.join ' '}"
    rescue
      raise "Open vSwitch (dpid = #{@dpid}) is already running!"
    end
    alias_method :start, :run

    def stop
      fail "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      pid = IO.read(pid_file).chomp
      sh "sudo kill #{pid}"
    end
    alias_method :shutdown, :stop

    def maybe_stop
      return unless running?
      stop
    end

    def bring_port_up(port_number)
      sh "sudo #{OFCTL} mod-port #{network_device} #{port_number} up"
    end

    def bring_port_down(port_number)
      sh "sudo #{OFCTL} mod-port #{network_device} #{port_number} down"
    end

    def dump_flows
      sh "sudo #{OFCTL} dump-flows #{network_device}"
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
      "#{Phut.pid_dir}/open_vswitch.#{name}.pid"
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
         --verbose=ANY:file:#{logging_level}
         --verbose=ANY:console:err
         --log-file=#{Phut.log_dir}/open_vswitch.#{name}.log
         --datapath-id=#{dpid_zero_filled}
         --unixctl=#{Phut.socket_dir}/open_vswitch.#{name}.ctl
         netdev@#{network_device} tcp:127.0.0.1:6633) +
        ports_option
    end
    # rubocop:enable MethodLength

    def dpid_zero_filled
      hex = format('%x', @dpid)
      '0' * (16 - hex.length) + hex
    end

    def logging_level
      @logger.level == Logger::DEBUG ? 'dbg' : 'info'
    end

    def ports_option
      @interfaces.empty? ? [] : ["--ports=#{@interfaces.join(',')}"]
    end
  end
end
