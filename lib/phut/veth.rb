# frozen_string_literal: true

require 'English'
require 'ipaddr'
require 'phut/shell_runner'

module Phut
  # Virtual eth device
  class Veth
    PREFIX = 'L'

    extend ShellRunner

    # rubocop:disable Metrics/AbcSize
    def self.all
      link_devices = sh('ip link show').split("\n").map do |each|
        case each
        when /^\d+: #{PREFIX}(\d+)_(\h{8})[@:]/
          ip_addr = IPAddr.new($LAST_MATCH_INFO[2].hex, Socket::AF_INET)
          new(name: ip_addr, link_id: $LAST_MATCH_INFO[1].to_i)
        when /^\d+: #{PREFIX}(\d+)_([^:]*?)[@:]/
          new(name: $LAST_MATCH_INFO[2], link_id: $LAST_MATCH_INFO[1].to_i)
        end
      end
      (Netns.all.map(&:device) + link_devices).compact
    end
    # rubocop:enable Metrics/AbcSize

    attr_reader :link_id

    def initialize(name:, link_id:)
      @name = valid_ipaddress?(name) ? IPAddr.new(name, Socket::AF_INET) : name
      @link_id = link_id
    end

    def name
      @name.to_s
    end

    def device
      if @name.is_a?(IPAddr)
        hex = format('%x', @name.to_i)
        "#{PREFIX}#{@link_id}_#{hex}"
      else
        "#{PREFIX}#{@link_id}_#{@name}"
      end
    end
    alias to_s device
    alias to_str device

    def ==(other)
      name == other.name && link_id == other.link_id
    end

    def <=>(other)
      device <=> other.device
    end

    private

    def valid_ipaddress?(string)
      IPAddr.new(string, Socket::AF_INET)
      true
    rescue
      false
    end
  end
end
