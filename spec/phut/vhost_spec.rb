# coding: utf-8
# frozen_string_literal: true
require 'faker'
require 'phut/link'
require 'phut/vhost'

module Phut
  describe Vhost do
    before(:each) do
      FileUtils.mkdir_p('./log') unless File.exist?('./log')
      FileUtils.mkdir_p('./tmp/pids') unless File.exist?('./tmp/pids')
      FileUtils.mkdir_p('./tmp/sockets') unless File.exist?('./tmp/sockets')

      Phut.log_dir = './log'
      Phut.pid_dir = './tmp/pids'
      Phut.socket_dir = './tmp/sockets'

      Vhost.all.each(&:stop)
    end

    after(:each) do
      Vhost.all.each(&:stop)
      Phut::Link.destroy_all
    end

    describe '.all' do
      Then { Vhost.all == [] }
    end

    describe '.create' do
      When(:host) do
        Vhost.create(name: 'myhost',
                     ip_address: Faker::Internet.ip_v4_address,
                     mac_address: Faker::Internet.mac_address,
                     device: device)
      end

      context 'with an invalid device' do
        Given(:device) { 'INVALID_DEVICE' }
        Then { pending '変なデバイスの場合 vhost run が exit status !=0 で死ぬようにする' }
      end

      context 'with a link device' do
        Given(:device) { Phut::Link.create('a', 'b').device('a') }
        Then { Vhost.all.size == 1 }
        Then { host.name == 'myhost' }
        Then { host.device == device }

        describe '#stop' do
          When { host.stop }
          Then { Vhost.all.empty? }
        end
      end
    end
  end
end
