# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'minitest/autorun'
require 'phut/link'

module Phut
  class LinkTest < Minitest::Test
    def test_link_all
      assert Link.all.empty?

      Link.create :switch1, :switch2
      assert_equal 1, Link.all.size
      assert_equal %w[switch1 switch2], Link.all.first.ends.map(&:name)

      Link.create :host1, :host2
      assert_equal 2, Link.all.size
      assert_equal %w[host1 host2], Link.all.second.ends.map(&:name)
    end

    def test_link_find
      assert_nil Link.find(:switch1, :switch2)

      link = Link.create(:switch1, :switch2)
      assert_equal link, Link.find(:switch1, :switch2)
      assert_equal link, Link.find(:switch2, :switch1)
      assert_equal link, Link.find('switch1', 'switch2')
      assert_equal link, Link.find('switch2', 'switch1')
    end

    def test_start
      link = Link.new(:switch1, :switch2)
      link.start

      assert_equal link, Link.all.first
      assert_equal link, link.start
    end

    def test_destroy
      link = Link.create(:switch1, :switch2)

      link.destroy
      assert Link.all.empty?
    end

    def test_ends
      link = Link.create(:switch1, :switch2)

      assert_equal 2, link.ends.size
      assert_equal 'switch1', link.ends.first.name
      assert_equal 'switch2', link.ends.second.name
    end

    def test_device
      link1 = Link.create(:switch1, :switch2)
      link2 = Link.create(:host1, :host2)

      assert_equal 'L0_switch1', link1.device(:switch1).to_s
      assert_equal 'L0_switch1', link1.device('switch1').to_s
      assert_equal 'L0_switch2', link1.device(:switch2).to_s
      assert_equal 'L0_switch2', link1.device('switch2').to_s

      assert_equal 'L1_host1', link2.device(:host1).to_s
      assert_equal 'L1_host1', link2.device('host1').to_s
      assert_equal 'L1_host2', link2.device(:host2).to_s
      assert_equal 'L1_host2', link2.device('host2').to_s

      assert_nil link1.device(:firewall)
    end

    private

    def setup
      log_dir = File.expand_path('../../log', __dir__)
      Phut.logger = ::Logger.new("#{log_dir}/test.log")
    end

    def teardown
      `ifconfig -a`.split("\n").each do |each|
        next unless /^(#{Veth::PREFIX}\S+)/ =~ each
        system "sudo ip link delete #{Regexp.last_match(1)} 2>/dev/null"
      end
    end
  end
end
