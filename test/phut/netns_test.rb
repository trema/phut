# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'minitest/autorun'
require 'phut/link'
require 'phut/netns'

module Phut
  class NetnsTest < Minitest::Test
    def test_netns_all
      assert Netns.all.empty?

      link = Link.create('host1', 'host2')

      host1 = Netns.create(name: 'host1', ip_address: '192.168.0.1')
      host1.device = link.device('host1')
      assert_equal 1, Netns.all.size
      assert_equal 'host1', Netns.all.first.name
      assert_equal '192.168.0.1', Netns.all.first.ip_address

      host2 = Netns.create(name: 'host2', ip_address: '192.168.0.1')
      host2.device = link.device('host2')
      assert_equal 2, Netns.all.size
      assert_equal 'host2', Netns.all.second.name
      assert_equal '192.168.0.1', Netns.all.second.ip_address
    end

    def test_netns_create
      netns = Netns.create(name: 'netns',
                           ip_address: '192.168.8.6',
                           netmask: '255.255.255.0',
                           route: { net: '0.0.0.0', gateway: '192.168.8.1' })
      assert_equal 'netns', netns.name
      assert_equal '192.168.8.6', netns.ip_address
    end

    def test_device
      link = Link.create('host', 'switch')
      netns = Netns.create(name: 'netns', ip_address: '192.168.0.1')

      netns.device = link.device('host')

      assert_equal 'host', netns.device.name
    end

    private

    def setup
      Netns.destroy_all
      Link.destroy_all
    end

    def teardown
      Netns.destroy_all
      Link.destroy_all
    end
  end
end
