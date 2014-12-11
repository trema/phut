require 'phut'

describe Phut::Parser do
  describe '#parse' do
    subject { Phut::Parser.new.parse configuration }

    context "with 'vswitch { dpid '0xabc' }'" do
      let(:configuration) { "vswitch { dpid '0xabc' }" }

      it { expect { subject }.not_to raise_error }

      describe '#vswitch' do
        subject { super().vswitch }

        it 'has 1 vswitch' do
          expect(subject.size).to eq(1)
        end
      end

      describe '#vswitch' do
        subject { super().vswitch }
        describe '#first' do
          subject { super().first }
          describe '#dpid' do
            subject { super().dpid }
            it { is_expected.to eq '0xabc' }
          end
        end
      end
    end

    context "with 'vhost { ip '192.168.0.1' }'" do
      let(:configuration) { "vhost { ip '192.168.0.1' }" }

      it { expect { subject }.not_to raise_error }

      describe '#vhost' do
        subject { super().vhost }

        it 'has 1 vhost' do
          expect(subject.size).to eq(1)
        end
      end

      describe '#vhost' do
        subject { super().vhost }
        describe '#first' do
          subject { super().first }
          describe '#ip' do
            subject { super().ip }
            it { is_expected.to eq '192.168.0.1' }
          end
        end
      end
    end
  end
end
