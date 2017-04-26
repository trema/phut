# frozen_string_literal: true

require 'faker'
require 'phut/vhost'

module Phut
  class VhostTest < Minitest::Test
    def test_vhost_all
      assert Vhost.all.empty?
    end

    def test_vhost_create
      link = Link.create('host', 'switch')
      vhost = Vhost.create(name: 'myhost',
                           ip_address: Faker::Internet.ip_v4_address,
                           mac_address: Faker::Internet.mac_address,
                           device: link.device('host'))

      assert_equal 1, Vhost.all.size
      assert_equal 'myhost', vhost.name
      assert_equal link.device('host'), vhost.device
    end

    def test_kill
      link = Link.create('host', 'switch')
      vhost = Vhost.create(name: 'myhost',
                           ip_address: Faker::Internet.ip_v4_address,
                           mac_address: Faker::Internet.mac_address,
                           device: link.device('host'))
      vhost.kill

      assert Vhost.all.empty?
    end

    private

    def setup
      Phut.log_dir = test_dir('log')
      Phut.pid_dir = test_dir('tmp/pids')
      Phut.socket_dir = test_dir('tmp/sockets')

      Vhost.all.each(&:kill)
    end

    def teardown
      Vhost.all.each(&:kill)
      Link.destroy_all
    end

    def test_dir(path)
      dir = File.expand_path(path, File.expand_path('../..', __dir__))
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
      dir
    end
  end
end
