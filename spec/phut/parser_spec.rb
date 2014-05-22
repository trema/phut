# -*- coding: utf-8 -*-
require 'phut/parser'

describe Phut::Parser do
  describe '#parse' do
    subject { Phut::Parser.new.parse configuration }

    context "with 'vswitch { dpid '0xabc' }'" do
      let(:configuration) { "vswitch { dpid '0xabc' }" }

      it { expect { subject }.not_to raise_error }
      its(:vswitch) { should have(1).vswitch }
      its('vswitch.first.dpid') { should eq '0xabc' }
    end

    context "with 'vhost { ip '192.168.0.1' }'" do
      let(:configuration) { "vhost { ip '192.168.0.1' }" }

      it { expect { subject }.not_to raise_error }
      its(:vhost) { should have(1).vhost }
      its('vhost.first.ip') { should eq '192.168.0.1' }
    end
  end
end
