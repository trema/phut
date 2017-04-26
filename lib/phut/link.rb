# frozen_string_literal: true

require 'phut/netns'
require 'phut/shell_runner'
require 'phut/veth'

module Phut
  # Virtual link
  class Link
    def self.all
      link = Hash.new { [] }
      Veth.all.each { |each| link[each.link_id] += [each.name] }
      link.map { |link_id, names| new(names.first, names.second, link_id) }
    end

    def self.find(end1, end2)
      all.find { |each| each.ends.map(&:name) == [end1, end2].map(&:to_s).sort }
    end

    def self.create(end1, end2)
      new(end1, end2).start
    end

    def self.destroy_all
      all.each(&:destroy)
    end

    include ShellRunner

    attr_reader :ends

    def initialize(name1, name2, link_id = Link.all.size)
      raise if name1 == name2
      @ends = [Veth.new(name: name1, link_id: link_id),
               Veth.new(name: name2, link_id: link_id)].sort
    end

    def start
      return self if up?
      add
      up
      self
    end

    def destroy
      sudo "ip link delete #{end1} || true"
      sudo "ip link delete #{end2} || true"
    end
    alias stop destroy

    def device(name)
      ends.find { |each| each.name == name.to_s }
    end

    def ==(other)
      ends == other.ends
    end

    private

    def end1
      ends.first
    end

    def end2
      ends.second
    end

    def add
      sudo "ip link add name #{end1.device} type veth peer name #{end2.device}"
      sudo "/sbin/sysctl -q -w net.ipv6.conf.#{end1.device}.disable_ipv6=1"
      sudo "/sbin/sysctl -q -w net.ipv6.conf.#{end2.device}.disable_ipv6=1"
    end

    def up?
      Link.all.include? self
    end

    def up
      sudo "/sbin/ifconfig #{end1.device} up"
      sudo "/sbin/ifconfig #{end2.device} up"
    end
  end
end
