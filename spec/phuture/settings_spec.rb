# -*- coding: utf-8 -*-

require 'phuture/settings'

describe Phuture::Settings do
  describe '.new' do
    subject { Phuture::Settings.new(root) }

    context %{with '.test'} do
      let(:root) { '.test' }
      its(['PID_DIR']) { should be_nil }
    end
  end
end
