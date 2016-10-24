# frozen_string_literal: true
require 'active_support/core_ext/array/access'
require 'phut/open_vswitch'

module Phut
  describe OpenVswitch do
    def delete_all_bridge
      `sudo ovs-vsctl list-br`.chomp.split.each do |each|
        next unless /^#{OpenVswitch.bridge_prefix}/ =~ each
        system "sudo ovs-vsctl del-br #{each}"
      end
    end

    after(:each) do
      delete_all_bridge
      OpenVswitch.bridge_prefix = ''
    end

    describe '.create' do
      When(:result) { OpenVswitch.create args }

      context 'with dpid: 0xc001' do
        Given(:args) { { dpid: 0xc001 } }

        context 'when there is no switch' do
          Then { result.dpid == 0xc001 }
          Then { result.name == '0xc001' }
          Then { result.bridge == '0xc001' }
          Then { result.openflow_version == 1.0 }
          Then { result.tcp_port == 6653 }
        end

        context 'when there is a switch with dpid = 0xc001' do
          Given { OpenVswitch.create(dpid: 0xc001) }

          Then { result == Failure(RuntimeError, 'a Vswitch #<Vswitch name: "0xc001", dpid: 0xc001, openflow_version: 1.0, tcp_port: 6653> already exists') }
        end
      end

      context "with name: 'dadi', dpid: 0xc001" do
        Given(:args) { { name: 'dadi', dpid: 0xc001 } }

        context 'when there is no switch' do
          Then { result.name == 'dadi' }
          Then { result.dpid == 0xc001 }
          Then { result.bridge == 'dadi' }
          Then { result.openflow_version == 1.0 }
          Then { result.tcp_port == 6653 }
        end

        context "when there is a switch with name: 'dadi', dpid: 0xdad1" do
          Given { OpenVswitch.create(name: 'dadi', dpid: 0xdad1) }

          Then { result == Failure(RuntimeError, 'a Vswitch #<Vswitch name: "dadi", dpid: 0xdad1, openflow_version: 1.0, tcp_port: 6653> already exists') }
        end
      end

      context "with dpid: 0xdad1, name: '1234567890123456'" do
        Given(:args) { { dpid: 0xdad1, name: '1234567890123456' } }

        Then { result == Failure(RuntimeError, "Name '1234567890123456' is too long (should be <= 15 chars)") }
      end

      context 'with dpid: 0xdad1, openflow_version: 1.0' do
        Given(:args) { { dpid: 0xdad1, openflow_version: 1.0 } }

        Then { result.openflow_version == 1.0 }
      end

      context 'with dpid: 0xdad1, openflow_version: 99999' do
        Given(:args) { { dpid: 0xdad1, openflow_version: 99_999 } }

        Then { result == Failure(RuntimeError, 'Invalid openflow_version: 99999') }
      end

      context 'with dpid: 0xdad1, tcp_port: 6666' do
        Given(:args) { { dpid: 0xdad1, tcp_port: 6666 } }

        Then { result.tcp_port == 6666 }

        context '#stop' do
          When { result.stop }
          Then { result.tcp_port.nil? }
        end
      end

      context 'with dpid: 0xdad1, tcp_port: -99999' do
        Given(:args) { { dpid: 0xdad1, tcp_port: -99_999 } }

        Then { result == Failure(RuntimeError) }
      end
    end

    context "when OpenVswitch.bridge_prefix == 'vsw_'" do
      Given { OpenVswitch.bridge_prefix = 'vsw_' }

      describe '.create' do
        When(:result) { OpenVswitch.create(args) }

        context "with dpid: 0xdad1, name: '1234567890123456'" do
          Given(:args) { { dpid: 0xdad1, name: '1234567890123456' } }

          Then { result == Failure(RuntimeError, "Name '1234567890123456' is too long (should be <= 11 chars)") }
        end
      end
    end

    describe '.destroy' do
      context "with '0xc001'" do
        When(:result) { OpenVswitch.destroy('0xc001') }

        context 'when there is no switch' do
          Then { result == Failure(RuntimeError, 'OpenVswitch {:name=>"0xc001"} not found') }
        end

        context 'when there is a switch with dpid = 0xc001' do
          Given { OpenVswitch.create dpid: 0xc001 }
          Then { OpenVswitch.all.empty? }
        end
      end
    end

    describe '.destroy_all' do
      When { OpenVswitch.destroy_all }

      context 'when there is no switch' do
        Then { OpenVswitch.all.empty? }
      end

      context 'when there is a switch with dpid = 0xc001' do
        Given { OpenVswitch.create dpid: 0xc001 }
        Then { OpenVswitch.all.empty? }
      end
    end

    describe '.all' do
      When(:all) { OpenVswitch.all }

      context 'when there is no switch' do
        Then { all.empty? }
      end

      context 'when there is a switch (dpid = 0xc001)' do
        Given { OpenVswitch.create dpid: 0xc001 }
        Then { all.size == 1 }
        Then { all.first.dpid == 0xc001 }
        Then { all.first.name == '0xc001' }
        Then { all.first.bridge == '0xc001' }
      end

      context 'when there are two switches (dpid = 0xdad1, 0xc001)' do
        Given { OpenVswitch.create dpid: 0xdad1 }
        Given { OpenVswitch.create dpid: 0xc001 }
        Then { all.size == 2 }
        Then { all.first.dpid == 0xc001 }
        Then { all.second.dpid == 0xdad1 }
      end
    end

    describe '.find_by' do
      Given { OpenVswitch.create name: 'dadi', dpid: 0xc001 }
      When(:result) { OpenVswitch.find_by name: 'dadi' }
      Then { result.name == 'dadi' }
      Then { result.dpid == 0xc001 }
    end

    describe '.dump_flows' do
      Given { OpenVswitch.create name: 'dadi', dpid: 0xc001 }
      When(:result) { OpenVswitch.dump_flows 'dadi' }
      Then { result == '' }
    end

    describe '.new' do
      When(:result) { OpenVswitch.new }
      Then { result == Failure(NoMethodError) }
    end

    describe '#add_port' do
      Given(:switch) { OpenVswitch.create dpid: 0xc001 }

      context "with 'port1'" do
        When { switch.add_port 'port1' }
        Then { switch.ports == ['port1'] }
      end
    end
  end
end
