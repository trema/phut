# frozen_string_literal: true
require 'active_support/core_ext/array/access'
require 'phut/open_vswitch'

module Phut
  describe OpenVswitch do
    def delete_all_bridge
      `sudo ovs-vsctl list-br`.chomp.split.each do |each|
        next unless /^#{OpenVswitch.prefix}/ =~ each
        system "sudo ovs-vsctl del-br #{each}"
      end
    end

    after(:each) { delete_all_bridge }

    describe '.all' do
      When(:all) { OpenVswitch.all }

      context 'when there is no switch' do
        Then { all == [] }
      end

      context 'when there is a switch (dpid = 0xc001)' do
        Given { OpenVswitch.create dpid: 0xc001 }
        Then { all.size == 1 }
        Then { all.first.dpid == 0xc001 }
      end
    end

    describe '.create' do
      context 'with dpid: 0xc001' do
        When(:switch) { OpenVswitch.create dpid: 0xc001 }

        context 'when there is no switch' do
          Then { switch.dpid == 0xc001 }
          Then { switch.name == '0xc001' }
          Then { switch.running? == true }
        end
      end

      context "with name: 'dadi', dpid: 0xc001" do
        When(:switch) { OpenVswitch.create name: 'dadi', dpid: 0xc001 }

        context 'when there is no switch' do
          Then { switch.name == 'dadi' }
          Then { switch.dpid == 0xc001 }
          Then { switch.running? == true }
        end
      end
    end

    describe '.find_by' do
      Given { OpenVswitch.create name: 'dadi', dpid: 0xc001 }
      When(:result) { OpenVswitch.find_by name: 'dadi' }
      Then { result.name == 'dadi' }
      Then { result.dpid == 0xc001 }
    end

    describe 'dump_flows' do
      Given { OpenVswitch.create name: 'dadi', dpid: 0xc001 }
      When(:result) { OpenVswitch.dump_flows 'dadi' }
      Then { result == '' }
    end

    describe '.destroy_all' do
      When { OpenVswitch.destroy_all }
      Then { OpenVswitch.all == [] }
    end

    describe '#add_port' do
      Given(:switch) { OpenVswitch.create dpid: 0xc001 }

      context "with 'port1'" do
        When { switch.add_port 'port1' }
        Then { switch.ports == ['port1'] }
      end
    end

    describe '#stop' do
      Given(:switch) { OpenVswitch.create dpid: 0xc001 }
      When { switch.stop }
      Then { switch.running? == false }
    end
  end
end
