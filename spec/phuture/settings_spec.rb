# -*- coding: utf-8 -*-

require 'phuture'

describe Phuture::Settings do
  describe '.new' do
    subject { Phuture::Settings.new(root) }

    context %{with '.test'} do
      let(:root) { '.test' }

      its(['PID_DIR']) { should eq Pathname('.test').expand_path.to_s }
    end
  end
end
