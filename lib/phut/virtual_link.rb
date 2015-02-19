require 'phut/null_logger'
require 'phut/shell_runner'

module Phut
  # Network virtual link.
  class VirtualLink
    include ShellRunner

    attr_reader :name_a
    attr_reader :name_b
    attr_reader :device_a
    attr_reader :device_b

    def initialize(name_a, device_a, name_b, device_b, logger = NullLogger.new)
      @name_a = name_a
      @device_a = device_a
      @name_b = name_b
      @device_b = device_b
      @logger = logger
    end

    def run
      add
      up
    end

    def stop
      delete
    end

    # @todo Use ifconfig command.
    def up?
      true
    end

    private

    def add
      delete if /^#{@device_a}\s+/ =~ `ifconfig -a`
      sh "sudo ip link add name #{@device_a} type veth peer name #{@device_b}"
      sh "sudo /sbin/sysctl -w net.ipv6.conf.#{@device_a}.disable_ipv6=1 -q"
      sh "sudo /sbin/sysctl -w net.ipv6.conf.#{@device_b}.disable_ipv6=1 -q"
    end

    def delete
      return unless /^#{@device_a}\s+/ =~ `ifconfig -a`
      sh "sudo ip link delete #{@device_a}"
    end

    def up
      sh "sudo /sbin/ifconfig #{@device_a} up"
      sh "sudo /sbin/ifconfig #{@device_b} up"
    end
  end
end
