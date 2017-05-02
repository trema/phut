# frozen_string_literal: true

require 'phut/finder'
require 'phut/setting'
require 'phut/shell_runner'
require 'phut/vhost_daemon'

module Phut
  # Virtual host for NetTester
  # rubocop:disable ClassLength
  class Vhost
    extend Finder

    attr_reader :ip_address
    attr_reader :mac_address

    def self.all
      Dir.glob(File.join(Phut.socket_dir, 'vhost.*.ctl')).map do |each|
        vhost = DRbObject.new_with_uri("drbunix:#{each}")
        new(name: vhost.name,
            ip_address: vhost.ip_address,
            mac_address: vhost.mac_address,
            device: vhost.device)
      end
    end

    def self.create(*args)
      new(*args).tap(&:start)
    end

    def self.destroy_all
      ::Dir.glob(File.join(Phut.socket_dir, 'vhost.*.ctl')).each do |each|
        /vhost\.(\S+)\.ctl/=~ each
        VhostDaemon.process(Regexp.last_match(1), Phut.socket_dir).kill
      end
    end

    def self.connect_link
      all.each do |each|
        Link.all.each do |link|
          device = link.device(each.name)
          each.device = device if device
        end
      end
    end

    # rubocop:disable ParameterLists
    def initialize(name:, ip_address:, mac_address:,
                   device: nil, promisc: false, arp_entries: nil)
      @name = name
      @ip_address = ip_address
      @mac_address = mac_address
      @device = device
      @promisc = promisc
      @arp_entries = arp_entries
    end
    # rubocop:enable ParameterLists

    include ShellRunner

    def name
      @name || @ip_address
    end

    # rubocop:disable LineLength
    def start
      if ENV['rvm_path']
        sh "rvmsudo vhost run #{run_options}"
      else
        vhost = File.expand_path('../../bin/vhost', __dir__)
        sh "bundle exec sudo env PATH=#{ENV['PATH']} #{vhost} run #{run_options}"
      end
      sleep 1
      self.device = @device if @device
    end
    alias run start
    # rubocop:enable LineLength

    def running?
      VhostDaemon.process(name, Phut.socket_dir).running?
    end

    def stop
      VhostDaemon.process(name, Phut.socket_dir).stop
    end

    def kill
      sh "bundle exec vhost stop -n #{name} -S #{Phut.socket_dir}"
      sleep 1
    end

    def device
      VhostDaemon.process(name, Phut.socket_dir).device
    end

    def device=(device_name)
      VhostDaemon.process(name, Phut.socket_dir).device = device_name
    end

    def send_packet(destination)
      VhostDaemon.process(name, Phut.socket_dir).send_packets(destination, 1)
    end

    def packets_sent_to(dest)
      VhostDaemon.process(name, Phut.socket_dir).stats[:tx].select do |each|
        (each[:destination_mac].to_s == dest.mac_address) &&
          (each[:destination_ip_address].to_s == dest.ip_address)
      end
    end

    def packets_received_from(source)
      VhostDaemon.process(name, Phut.socket_dir).stats[:rx].select do |each|
        (each[:source_mac].to_s == source.mac_address) &&
          (each[:source_ip_address].to_s == source.ip_address)
      end
    end

    def set_default_arp_table
      arp_table = Vhost.all.each_with_object({}) do |each, hash|
        hash[each.ip_address] = each.mac_address
      end
      VhostDaemon.process(name, Phut.socket_dir).arp_table = arp_table
    end

    def to_s
      "vhost (name = #{name}, IP address = #{@ip_address})"
    end

    private

    def run_options
      ["-n #{name}",
       "-i #{ip_address}",
       "-m #{mac_address}",
       @arp_entries ? "-a #{@arp_entries}" : nil,
       @promisc ? '--promisc' : nil,
       "-L #{Phut.log_dir}",
       "-P #{Phut.pid_dir}",
       "-S #{Phut.socket_dir}"].compact.join(' ')
    end
  end
  # rubocop:enable ClassLength
end
