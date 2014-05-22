# -*- coding: utf-8 -*-

require 'phut'
require 'tmpdir'

describe Phut::Settings do
  describe '.new' do
    subject { Phut::Settings.new(root) }

    context %(with '.test') do
      let(:root) { '.test' }

      its(['PID_DIR']) { should eq Dir.tmpdir }
      its(['LOG_DIR']) { should eq Dir.tmpdir }
      its(['SOCKET_DIR']) { should eq Dir.tmpdir }
    end
  end
end
