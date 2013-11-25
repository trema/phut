# -*- coding: utf-8 -*-

require 'phuture'
require 'tmpdir'

describe Phuture::Settings do
  describe '.new' do
    subject { Phuture::Settings.new(root) }

    context %{with '.test'} do
      let(:root) { '.test' }

      its(['PID_DIR']) { should eq Dir.tmpdir }
      its(['LOG_DIR']) { should eq Dir.tmpdir }
      its(['SOCKET_DIR']) { should eq Dir.tmpdir }
    end
  end
end
