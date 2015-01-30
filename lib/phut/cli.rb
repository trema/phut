require 'rake'
require 'phut/settings'

module Phut
  # cli command wrapper.
  class Cli
    include FileUtils

    def initialize(host)
      @host = host
    end

    def send_packets(dest, options = {})
      sh("#{executable} -i #{@host.interface} send_packets " \
         "--ip_src #{@host.ip} --ip_dst #{dest.ip} " +
         send_packets_options(options), verbose: false)
    end

    def show_tx_stats
      puts stats(:tx)
    end

    def show_rx_stats
      puts stats(:rx)
    end

    def add_arp_entry(other)
      sh "sudo #{executable} -i #{@host.interface} add_arp_entry " \
         "--ip_addr #{other.ip} --mac_addr #{other.mac}", verbose: false
    end

    def set_ip_and_mac_address
      sh "sudo #{executable} -i #{@host.interface} set_host_addr " \
         "--ip_addr #{@host.ip} --ip_mask #{@host.netmask} " \
         "--mac_addr #{@host.mac}", verbose: false
    end

    private

    def executable
      "#{Phut::ROOT}/vendor/phost/src/cli"
    end

    def send_packets_options(options)
      [
        '--tp_src 1',
        '--tp_dst 1',
        '--pps 1',
        '--length 22',
        options[:n_pkts] ? nil : '--duration 1',
        options[:n_pkts] ? "--n_pkts=#{options[:n_pkts]}" : nil
      ].compact.join(' ')
    end

    def stats(type)
      `sudo #{executable} -i #{@host.interface} show_stats --#{type}`
    end
  end
end
