require 'phut/cli'
require 'phut/settings'
require 'pio/mac'
require 'rake'

module Phut
  # An interface class to phost emulation utility program.
  class Phost
    include FileUtils

    attr_reader :ip
    attr_reader :name
    attr_reader :mac
    attr_accessor :interface

    def initialize(ip_address, name = nil)
      @ip = ip_address
      @name = name || @ip
      @mac = Pio::Mac.new(rand(0xffffffffffff + 1))
    end

    def run(hosts = [])
      sh "sudo #{executable} #{options.join ' '}", verbose: false
      sleep 1
      set_ip_and_mac_address
      add_arp_entries hosts
    end

    def stop
      pid = IO.read(pid_file)
      sh "sudo kill #{pid}", verbose: false
    end

    def netmask
      '255.255.255.255'
    end

    private

    def set_ip_and_mac_address
      Phut::Cli.new(self).set_ip_and_mac_address
    end

    def add_arp_entries(hosts)
      hosts.each do |each|
        Phut::Cli.new(self).add_arp_entry each
      end
    end

    def pid_file
      "#{Phut.settings['PID_DIR']}/phost.#{name}.pid"
    end

    def executable
      "#{Phut::ROOT}/vendor/phost/src/phost"
    end

    def options
      %W(-p #{Phut.settings['PID_DIR']}
         -l #{Phut.settings['LOG_DIR']}
         -n #{name}
         -i #{interface}
         -D)
    end
  end
end
