# frozen_string_literal: true

require 'phut/shell_runner'

module Phut
  # routing table entry
  class Route
    extend ShellRunner

    def self.read(netns)
      sudo("ip netns exec #{netns} route -n").split("\n").each do |each|
        match = /^(\S+)\s+(\S+)\s+\S+\s+UG\s+/.match(each)
        next unless match
        return new(net: match[1], gateway: match[2])
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
      return unless @net && @gateway
      sudo "ip netns exec #{netns} route add -net #{@net} gw #{@gateway}"
    end
  end
end
