# -*- coding: utf-8 -*-
require 'phuture/parser'

describe Phuture::Parser do
  describe '#parse' do
    subject { Phuture::Parser.new.parse configuration }

    context "with 'vswitch { dpid 0xabc }'" do
      let(:configuration) { 'vswitch { dpid 0xabc }' }

      it { expect { subject }.not_to raise_error }
      its(:vswitch) { should have(1).vswitch }
      its('vswitch.first.dpid') { should eq 0xabc }
    end
  end
end
