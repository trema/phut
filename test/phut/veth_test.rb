# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'minitest/autorun'
require 'phut/link'
require 'phut/veth'

module Phut
  class VethTest < Minitest::Test
    def test_veth_all
      assert Veth.all.empty?

      Link.create :switch1, :switch2
      assert_equal 2, Veth.all.size
      assert_equal 'switch1', Veth.all.sort.first.name
      assert_equal 'switch2', Veth.all.sort.second.name
    end

    def test_name
      assert_equal 'switch1', Veth.new(name: 'switch1', link_id: 0).name
      assert_equal '192.168.0.1', Veth.new(name: '192.168.0.1', link_id: 0).name
    end

    def test_device
      assert_equal 'L0_switch1', Veth.new(name: 'switch1', link_id: 0).device
      assert_equal 'L0_c0a80001', Veth.new(name: '192.168.0.1', link_id: 0).device
    end

    private

    def setup
      log_dir = File.expand_path('../../log', __dir__)
      Phut.logger = ::Logger.new("#{log_dir}/test.log")
      destroy_all
    end

    def teardown
      destroy_all
    end

    def destroy_all
      `ifconfig -a`.split("\n").each do |each|
        next unless /^(#{Veth::PREFIX}\S+)/ =~ each
        system "sudo ip link delete #{Regexp.last_match(1)} 2>/dev/null"
      end
    end
  end
end
