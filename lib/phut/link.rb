# frozen_string_literal: true
require 'phut/netns'
require 'phut/shell_runner'
require 'phut/veth'

module Phut
  # Virtual link
  class Link
    def self.all
      link = Hash.new { [] }
      Veth.each { |link_id, name| link[link_id] += [name] }
      link.map { |link_id, names| new(*names, link_id: link_id) }
    end

    def self.find(names)
      all.find { |each| each.names == names.sort }
    end

    def self.each(&block)
      all.each(&block)
    end

    def self.select(&block)
      all.select(&block)
    end

    def self.create(name_a, name_b)
      new(name_a, name_b).start
    end

    def self.destroy_all
      all.each(&:destroy)
    end

    include ShellRunner

    def initialize(name_a, name_b, link_id: Link.all.size)
      raise if name_a == name_b
      @veth_a = Veth.new(name: name_a, link_id: link_id)
      @veth_b = Veth.new(name: name_b, link_id: link_id)
    end

    def names
      [@veth_a, @veth_b].map(&:name).sort
    end

    def device(name)
      [@veth_a, @veth_b].each do |each|
        return each.to_s if each.name == name.to_s
      end
      nil
    end

    def start
      stop if up?
      add
      up
      self
    end

    def destroy
      return unless up?
      sudo "ip link delete #{@veth_a}"
    rescue
      raise "link #{@veth_a} #{@veth_b} does not exist!"
    end
    alias stop destroy

    def up?
      /^#{@veth_a}\s+Link encap:Ethernet/ =~ `LANG=C ifconfig -a` || false
    end

    def connect_to?(vswitch)
      device(vswitch.name) || false
    end

    def ==(other)
      @veth_a == other.veth_a && @veth_b == other.veth_b
    end

    private

    def add
      sudo "ip link add name #{@veth_a} type veth peer name #{@veth_b}"
      sudo "/sbin/sysctl -q -w net.ipv6.conf.#{@veth_a}.disable_ipv6=1"
      sudo "/sbin/sysctl -q -w net.ipv6.conf.#{@veth_b}.disable_ipv6=1"
    end

    def up
      sudo "/sbin/ifconfig #{@veth_a} up"
      sudo "/sbin/ifconfig #{@veth_b} up"
    end
  end
end
