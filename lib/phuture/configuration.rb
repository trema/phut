# -*- coding: utf-8 -*-

module Phuture
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :link

    def initialize
      @vswitch = []
      @vhost = []
      @link = []
    end

    def find_link(peer_a, peer_b)
      @link.select do |each|
        each.peer_a == peer_a && each.peer_b == peer_b
      end[0]
    end
  end
end
