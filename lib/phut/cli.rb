require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'

module Phut
  # cli command wrapper.
  class Cli
    include ShellRunner

    def initialize(host, logger = NullLogger.new)
      @host = host
      @logger = logger
    end

    def send_packets(dest, options = {})
      n_pkts = options[:n_pkts]
      sh [executable,
          "-i #{@host.interface} send_packets",
          "--ip_dst #{dest.ip}",
          "--ip_src #{@host.ip}",
          '--tp_src 1',
          '--tp_dst 1',
          '--pps 1',
          '--length 22',
          n_pkts ? "--n_pkts=#{n_pkts}" : '--duration 1'].join(' ')
    end

    def show_tx_stats
      puts stats(:tx)
    end

    def show_rx_stats
      puts stats(:rx)
    end

    def add_arp_entry(other)
      sh "sudo #{executable} -i #{@host.interface} add_arp_entry " \
         "--ip_addr #{other.ip} --mac_addr #{other.mac}"
    end

    def set_ip_and_mac_address
      sh "sudo #{executable} -i #{@host.interface} set_host_addr " \
         "--ip_addr #{@host.ip} --ip_mask #{@host.netmask} " \
         "--mac_addr #{@host.mac}"
    end

    def enable_promisc
      sh "sudo #{executable} -i #{@host.interface} enable_promisc"
    end

    private

    def executable
      "#{Phut.root}/vendor/phost/src/cli"
    end

    def stats(type)
      `sudo #{executable} -i #{@host.interface} show_stats --#{type}`
    end
  end
end
