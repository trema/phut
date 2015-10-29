require 'phut/null_logger'
require 'phut/shell_runner'

module Phut
  # `ip netns ...` command runner
  class Netns
    include ShellRunner

    attr_reader :name
    attr_accessor :network_device

    def initialize(options, name, logger = NullLogger.new)
      @name = name
      @options = options
      @logger = logger
    end

    # rubocop:disable AbcSize
    def run
      sh "sudo ip netns add #{name}"
      sh "sudo ip link set dev #{network_device} netns #{name}"
      sh "sudo ip netns exec #{name} ifconfig lo 127.0.0.1"
      sh "sudo ip netns exec #{name}"\
         " ifconfig #{network_device} #{ip} netmask #{netmask}"
      sh "sudo ip netns exec #{name} route add -net #{net} gw #{gateway}"
    end
    # rubocop:enable AbcSize

    def maybe_stop
      sh "sudo ip netns delete #{name}"
    end

    def method_missing(message, *_args)
      @options.__send__ :[], message
    end
  end
end
