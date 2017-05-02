# frozen_string_literal: true

require 'minitest/autorun'
require 'phut/open_vswitch'

module Phut
  class OpenVswitchTest < Minitest::Test
    def test_open_vswitch_all
      assert OpenVswitch.all.empty?

      OpenVswitch.create(dpid: 0xc001)
      assert_equal 1, OpenVswitch.all.size
      assert_equal 0xc001, OpenVswitch.all.first.dpid
      assert_equal '0xc001', OpenVswitch.all.first.name
      assert_equal '0xc001', OpenVswitch.all.first.bridge
      assert_equal 1.0, OpenVswitch.all.first.openflow_version
      assert_equal 6653, OpenVswitch.all.first.tcp_port

      OpenVswitch.create(dpid: 0xdad1)
      assert_equal 2, OpenVswitch.all.size
      assert_equal 0xdad1, OpenVswitch.all.second.dpid
      assert_equal '0xdad1', OpenVswitch.all.second.name
      assert_equal '0xdad1', OpenVswitch.all.second.bridge
      assert_equal 1.0, OpenVswitch.all.second.openflow_version
      assert_equal 6653, OpenVswitch.all.second.tcp_port
    end

    def test_open_vswitch_create_with_dpid
      vswitch = OpenVswitch.create(dpid: 0xc001)
      assert_equal 0xc001, vswitch.dpid
      assert_equal '0xc001', vswitch.name
      assert_equal '0xc001', vswitch.bridge
      assert_equal 1.0, vswitch.openflow_version
      assert_equal 6653, vswitch.tcp_port

      assert_raises(RuntimeError) do
        OpenVswitch.create(dpid: 0xc001)
      end
    end

    def test_open_vswitch_create_with_name_and_dpid
      vswitch = OpenVswitch.create(name: 'dadi', dpid: 0xc001)
      assert_equal 0xc001, vswitch.dpid
      assert_equal 'dadi', vswitch.name
      assert_equal 'dadi', vswitch.bridge
      assert_equal 1.0, vswitch.openflow_version
      assert_equal 6653, vswitch.tcp_port

      assert_raises(RuntimeError) do
        OpenVswitch.create(name: 'dadi', dpid: 0xc001)
      end
    end

    def test_open_vswitch_create_exceptions
      assert_raises(RuntimeError) do
        OpenVswitch.create(dpid: 0xdad1, name: '1234567890123456')
      end

      assert_raises(RuntimeError) do
        OpenVswitch.create(dpid: 0xdad1, openflow_version: 999)
      end

      assert_raises(RuntimeError) do
        OpenVswitch.create(dpid: 0xdad1, tcp_port: -999)
      end
    end

    def test_open_vswitch_find_by
      OpenVswitch.create(dpid: 0xc001)
      vswitch = OpenVswitch.find_by(dpid: 0xc001)
      assert_equal '0xc001', vswitch.name
      assert_equal 0xc001, vswitch.dpid
    end

    def test_open_vswitch_destroy
      OpenVswitch.create(dpid: 0xc001)
      OpenVswitch.destroy('0xc001')
      assert OpenVswitch.all.empty?
    end

    def test_open_vswitch_destroy_all
      OpenVswitch.create(dpid: 0xc001)
      OpenVswitch.destroy_all
      assert OpenVswitch.all.empty?
    end

    def test_new
      assert_raises(NoMethodError) do
        OpenVswitch.new
      end
    end

    def test_destroy
      vswitch = OpenVswitch.create(dpid: 0xc001)
      vswitch.destroy
      assert OpenVswitch.all.empty?
    end

    def test_stop
      vswitch = OpenVswitch.create(dpid: 0xc001)
      vswitch.stop
      assert vswitch.tcp_port.nil?
    end

    def test_dump_flows
      vswitch = OpenVswitch.create(dpid: 0xc001)
      assert_equal '', vswitch.dump_flows
    end

    def test_add_port
      vswitch = OpenVswitch.create(dpid: 0xc001)
      vswitch.add_port 'port1'
      assert_equal ['port1'], vswitch.ports
    end

    private

    def teardown
      `sudo ovs-vsctl list-br`.chomp.split.each do |each|
        next unless /^#{OpenVswitch.bridge_prefix}/ =~ each
        system "sudo ovs-vsctl del-br #{each}"
      end
    end
  end
end
