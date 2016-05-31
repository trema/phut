# frozen_string_literal: true
require 'ipaddr'
require 'phut/shell_runner'
require 'phut/virtual_link'

module Phut
  # Virtual link
  class Link
    LINK_DEVICE_PREFIX = 'L'
    # rubocop:disable LineLength
    IPADDR_REGEX = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
    # rubocop:enable LineLength

    extend ShellRunner

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def self.all
      link = Hash.new { [] }
      devices.each do |each|
        case each
        when /^#{LINK_DEVICE_PREFIX}(\d+)_(\h{8})/
          name = IPAddr.new(Regexp.last_match(2).hex, Socket::AF_INET).to_s
          link[Regexp.last_match(1).to_i] += [name]
        when /^#{LINK_DEVICE_PREFIX}(\d+)_(\S+)/
          link[Regexp.last_match(1).to_i] += [Regexp.last_match(2)]
        end
      end
      link.map { |link_id, names| new(*names, link_id: link_id) }
    end
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize

    def self.find(names)
      all.find { |each| each.names == names.sort }
    end

    def self.each(&block)
      all.each(&block)
    end

    def self.select(&block)
      all.select(&block)
    end

    def self.devices
      sh('LANG=C ifconfig -a').split("\n").map do |each|
        /^(#{LINK_DEVICE_PREFIX}\d+_\S+)/ =~ each ? Regexp.last_match(1) : nil
      end.compact
    end

    def self.create(name_a, name_b)
      new(name_a, name_b).start
    end

    def self.destroy_all
      all.each(&:destroy)
    end

    def initialize(name_a, name_b, link_id: Link.all.size)
      @link = VirtualLink.new(device_name(link_id, name_a),
                              device_name(link_id, name_b))
      @device = [name_a, name_b].each_with_object({}) do |each, hash|
        hash[each.to_s] = device_name(link_id, each)
      end
    end

    def names
      @device.keys.sort
    end

    def device(name)
      @device[name.to_s]
    end

    def start
      @link.run
      self
    end

    def destroy
      @link.stop
    end
    alias stop destroy

    def connect_to?(vswitch)
      device(vswitch.name) || false
    end

    private

    def device_name(link_id, name)
      if IPADDR_REGEX =~ name
        hex = format('%x', IPAddr.new(name).to_i)
        "#{LINK_DEVICE_PREFIX}#{link_id}_#{hex}"
      else
        "#{LINK_DEVICE_PREFIX}#{link_id}_#{name}"
      end
    end
  end
end
