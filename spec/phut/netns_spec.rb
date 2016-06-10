# frozen_string_literal: true

require 'phut/link'
require 'phut/netns'

module Phut
  describe Netns do
    before(:each) do
      Netns.destroy_all
      Link.destroy_all
    end

    after(:each) do
      Netns.destroy_all
      Link.destroy_all
    end

    describe '.create' do
      When(:netns) do
        Netns.create(name: name,
                     ip_address: '192.168.8.6',
                     netmask: '255.255.255.0',
                     route: { net: '0.0.0.0', gateway: '192.168.8.1' })
      end

      context "with name: 'netns'" do
        Given(:name) { 'netns' }
        Then { netns.name == 'netns' }
      end
    end

    describe '.all' do
      When(:all) { Netns.all }

      context 'when there is no netns' do
        Then { all == [] }
      end

      context 'when there is a netns named "foo"' do
        Given do
          Netns.create(name: 'foo', ip_address: '192.168.0.1')
        end
        Then { all.size == 1 }
        Then { all.first.name == 'foo' }
      end

      context 'when there are two netns' do
        Given do
          Netns.create(name: 'foo', ip_address: '192.168.0.1')
          Netns.create(name: 'bar', ip_address: '192.168.0.1')
        end
        Then { all.size == 2 }
        Then { all.first.name == 'bar' }
      end
    end

    context 'when there is a link "name1" <=> "name2"' do
      Given(:link) { Link.create(:name1, :name2) }

      describe '#device=' do
        Given(:netns) do
          Netns.create(name: 'netns', ip_address: '192.168.0.1')
        end
        When { netns.device = link.device(peer_name) }

        context 'with "name1"' do
          When(:peer_name) { 'name1' }
          Then { netns.device == 'L0_name1' }
        end
      end
    end
  end
end
