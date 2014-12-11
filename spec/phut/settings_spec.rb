require 'phut'
require 'tmpdir'

describe Phut::Settings do
  describe '.new' do
    subject { Phut::Settings.new(root) }

    context %(with '.test') do
      let(:root) { '.test' }

      describe "['PID_DIR']" do
        subject { super()['PID_DIR'] }
        it { is_expected.to eq Dir.tmpdir }
      end

      describe "['LOG_DIR']" do
        subject { super()['LOG_DIR'] }
        it { is_expected.to eq Dir.tmpdir }
      end

      describe "['SOCKET_DIR']" do
        subject { super()['SOCKET_DIR'] }
        it { is_expected.to eq Dir.tmpdir }
      end
    end
  end
end
