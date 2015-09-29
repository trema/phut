require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'
require 'pio/mac'

module Phut
  # An interface class to vhost emulation utility program.
  class Vhost
    include ShellRunner

    attr_reader :ip_address
    attr_reader :mac_address
    attr_accessor :network_device

    def initialize(ip_address, mac_address, promisc,
                   name = nil, logger = NullLogger.new)
      @ip_address = ip_address
      @promisc = promisc
      @name = name
      @mac_address = mac_address
      @logger = logger
    end

    def name
      @name || @ip_address
    end

    def to_s
      "vhost (name = #{name}, IP address = #{@ip_address})"
    end

    def run(all_hosts = [])
      @all_hosts ||= all_hosts
      if ENV['rvm_path']
        sh "rvmsudo vhost run #{run_options}"
      else
        vhost = File.join(__dir__, '..', '..', 'bin', 'vhost')
        sh "bundle exec sudo #{vhost} run #{run_options}"
      end
    end

    def stop
      fail "vhost (name = #{name}) is not running!" unless running?
      sh "vhost stop -n #{name} -s #{Phut.socket_dir}"
    end

    def maybe_stop
      return unless running?
      stop
    end

    def running?
      FileTest.exists?(pid_file)
    end

    private

    def run_options
      ["-n #{name}",
       "-I #{@network_device}",
       "-i #{@ip_address}",
       "-m #{@mac_address}",
       "-a #{arp_entries}",
       @promisc ? '--promisc' : nil,
       "-P #{Phut.pid_dir}",
       "-L #{Phut.log_dir}",
       "-S #{Phut.socket_dir}"].compact.join(' ')
    end

    def arp_entries
      @all_hosts.map do |each|
        "#{each.ip_address}/#{each.mac_address}"
      end.join(',')
    end

    def pid_file
      "#{Phut.pid_dir}/vhost.#{name}.pid"
    end
  end
end
