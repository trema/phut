# frozen_string_literal: true
require 'ipaddr'
require 'phut/shell_runner'

module Phut
  # Virtual eth device
  class Veth
    PREFIX = 'L'

    extend ShellRunner

    def self.all
      Netns.all.map(&:device).compact +
        sh('ip -o link show').split("\n").map do |each|
          /^\d+: (#{PREFIX}\d+_[^:]*?)[@:]/ =~ each ? Regexp.last_match(1) : nil
        end.compact
    end

    def self.each(&block)
      all.each do |each|
        veth = parse(each)
        block.yield veth[:link_id], veth[:name]
      end
    end

    def self.parse(veth_name)
      unless /^#{PREFIX}(\d+)_(\S+)/ =~ veth_name
        raise "Failed to parse veth name: #{veth_name}"
      end
      link_id = Regexp.last_match(1).to_i
      name = Regexp.last_match(2)
      if /^\h{8}$/ =~ name
        { name: IPAddr.new(name.hex, Socket::AF_INET).to_s, link_id: link_id }
      else
        { name: name, link_id: link_id }
      end
    end

    attr_reader :name

    def initialize(name:, link_id:)
      @name = name.to_s
      @link_id = link_id
    end

    def ==(other)
      to_s == other.to_s
    end

    # rubocop:disable LineLength
    def to_s
      if /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/ =~ @name
        hex = format('%x', IPAddr.new(@name).to_i)
        "#{PREFIX}#{@link_id}_#{hex}"
      else
        "#{PREFIX}#{@link_id}_#{@name}"
      end
    end
    # rubocop:enable LineLength
  end
end
