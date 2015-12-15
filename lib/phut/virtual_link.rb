require 'active_support/core_ext/class/attribute_accessors'
require 'phut/null_logger'
require 'phut/shell_runner'

module Phut
  # Network virtual link.
  class VirtualLink
    cattr_accessor(:all, instance_reader: false) { [] }

    def self.create(name_a, name_b, logger = NullLogger.new)
      new(name_a, name_b, logger).tap { |vlink| all << vlink }
    end

    def self.each(&block)
      all.each(&block)
    end

    # Creates a valid network device name.
    class NetworkDeviceName
      attr_reader :name
      attr_writer :port_number

      def initialize(name)
        @name = name
      end

      def to_s
        @name.tr('.', '_') + port_number_string
      end

      def inspect
        to_s
      end

      private

      def port_number_string
        @port_number ? '_' + @port_number.to_s : ''
      end
    end

    include ShellRunner

    attr_reader :name_a
    attr_reader :name_b
    attr_reader :device_a
    attr_reader :device_b

    def initialize(name_a, name_b, logger)
      fail if name_a == name_b
      @name_a = name_a
      @name_b = name_b
      @device_a = NetworkDeviceName.new(name_a)
      @device_b = NetworkDeviceName.new(name_b)
      @logger = logger
    end

    def ==(other)
      @name_a == other.name_a &&
        @name_b == other.name_b &&
        @device_a == other.device_a &&
        @device_b == other.device_b
    end

    def run
      stop if up?
      add
      up
    end

    def stop
      return unless up?
      stop!
    end

    def stop!
      sh "sudo ip link delete #{@device_a}"
    rescue
      raise "link #{@name_a} #{@name_b} does not exist!"
    end

    def up?
      /^#{@device_a}\s+Link encap:Ethernet/ =~ `LANG=C ifconfig -a` || false
    end

    def connect_to?(vswitch)
      find_network_device(vswitch) || false
    end

    def find_network_device(vswitch_or_vhost)
      [@device_a, @device_b].detect do |each|
        each.name == vswitch_or_vhost.name
      end
    end

    private

    def add
      sh "sudo ip link add name #{@device_a} type veth peer name #{@device_b}"
      sh "sudo /sbin/sysctl -q -w net.ipv6.conf.#{@device_a}.disable_ipv6=1"
      sh "sudo /sbin/sysctl -q -w net.ipv6.conf.#{@device_b}.disable_ipv6=1"
    end

    def up
      sh "sudo /sbin/ifconfig #{@device_a} up"
      sh "sudo /sbin/ifconfig #{@device_b} up"
    end
  end
end
