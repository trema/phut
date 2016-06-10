# frozen_string_literal: true
require 'phut/shell_runner'

module Phut
  # routing table entry
  class Route
    extend ShellRunner

    def self.read(netns)
      sudo("ip netns exec #{netns} route -n").split("\n").each do |each|
        next unless /^(\S+)\s+(\S+)\s+\S+\s+UG\s+/ =~ each
        return new(net: Regexp.last_match(1),
                   gateway: Regexp.last_match(2))
      end
      nil
    end

    attr_reader :net
    attr_reader :gateway

    def initialize(net:, gateway:)
      @net = net
      @gateway = gateway
    end

    include ShellRunner

    def add(netns)
      if @net && @gateway
        sudo "ip netns exec #{netns} route add -net #{@net} gw #{@gateway}"
      end
    end
  end
end
