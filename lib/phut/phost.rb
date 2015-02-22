require 'phut/cli'
require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'
require 'pio/mac'

module Phut
  # An interface class to phost emulation utility program.
  class Phost
    include ShellRunner

    attr_reader :ip
    attr_reader :name
    attr_reader :mac
    attr_accessor :interface

    def initialize(ip_address, promisc, name = nil, logger = NullLogger.new)
      @ip = ip_address
      @promisc = promisc
      @name = name || @ip
      @mac = Pio::Mac.new(rand(0xffffffffffff + 1))
      @logger = logger
    end

    def to_s
      "vhost (name = #{@name}, ip = #{@ip})"
    end

    def run(hosts = [])
      sh "sudo #{executable} #{options.join ' '}"
      sleep 1
      set_ip_and_mac_address
      maybe_enable_promisc
      add_arp_entries hosts
    end

    def stop
      pid = IO.read(pid_file)
      sh "sudo kill #{pid}"
      loop { break unless running? }
    end

    def netmask
      '255.255.255.255'
    end

    def running?
      FileTest.exists?(pid_file)
    end

    private

    def set_ip_and_mac_address
      Phut::Cli.new(self, @logger).set_ip_and_mac_address
    end

    def maybe_enable_promisc
      return unless @promisc
      Phut::Cli.new(self).enable_promisc
    end

    def add_arp_entries(hosts)
      hosts.each do |each|
        Phut::Cli.new(self).add_arp_entry each
      end
    end

    def pid_file
      "#{Phut.pid_dir}/phost.#{name}.pid"
    end

    def executable
      "#{Phut.root}/vendor/phost/src/phost"
    end

    def options
      %W(-p #{Phut.pid_dir}
         -l #{Phut.log_dir}
         -n #{name}
         -i #{interface}
         -D)
    end
  end
end
