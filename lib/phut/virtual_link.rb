require 'rake'

module Phut
  # Network virtual link.
  class VirtualLink
    include FileUtils

    attr_reader :name_a
    attr_reader :name_b
    attr_reader :device_a
    attr_reader :device_b

    def initialize(name_a, device_a, name_b, device_b)
      @name_a = name_a
      @device_a = device_a
      @name_b = name_b
      @device_b = device_b
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
      delete if /^#{@device_a}\s+/ =~ `ifconfig`
      sh("sudo ip link add name #{@device_a} type veth peer name #{@device_b}",
         verbose: Phut.settings[:verbose])
      sh("sudo /sbin/sysctl -w net.ipv6.conf.#{@device_a}.disable_ipv6=1 -q",
         verbose: Phut.settings[:verbose])
      sh("sudo /sbin/sysctl -w net.ipv6.conf.#{@device_b}.disable_ipv6=1 -q",
         verbose: Phut.settings[:verbose])
    end

    def delete
      sh "sudo ip link delete #{@device_a}", verbose: Phut.settings[:verbose]
    end

    def up
      sh "sudo /sbin/ifconfig #{@device_a} up", verbose: Phut.settings[:verbose]
      sh "sudo /sbin/ifconfig #{@device_b} up", verbose: Phut.settings[:verbose]
    end
  end
end
