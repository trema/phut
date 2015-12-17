require 'active_support/core_ext/class/attribute_accessors'
require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'
require 'pio/mac'

module Phut
  # An interface class to vhost emulation utility program.
  class Vhost
    cattr_accessor(:all, instance_reader: false) { [] }

    def self.create(ip_address, mac_address, promisc, name = nil,
                    logger = NullLogger.new)
      new(ip_address, mac_address, promisc, name, logger).tap do |vhost|
        conflict = find_by(name: vhost.name)
        fail "The name #{vhost.name} conflicts with #{conflict}." if conflict
        all << vhost
      end
    end

    # This method smells of :reek:NestedIterators but ignores them
    def self.find_by(queries)
      queries.inject(all) do |memo, (attr, value)|
        memo.find_all { |vhost| vhost.__send__(attr) == value }
      end.first
    end

    def self.each(&block)
      all.each(&block)
    end

    include ShellRunner

    attr_reader :ip_address
    attr_reader :mac_address
    attr_accessor :network_device

    def initialize(ip_address, mac_address, promisc, name, logger)
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

    def run(all_hosts = Vhost.all)
      @all_hosts ||= all_hosts
      if ENV['rvm_path']
        sh "rvmsudo vhost run #{run_options}"
      else
        vhost = File.join(__dir__, '..', '..', 'bin', 'vhost')
        sh "bundle exec sudo #{vhost} run #{run_options}"
      end
    end

    def stop
      return unless running?
      stop!
    end

    def stop!
      fail "vhost (name = #{name}) is not running!" unless running?
      sh "vhost stop -n #{name} -S #{Phut.socket_dir}"
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
