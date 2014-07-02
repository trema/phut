# encoding: utf-8

describe Phut::OpenVswitch do
  describe '.new' do
    context 'with 0xabc' do
      Given(:open_vswitch) do
        open_vswitch = Phut::OpenVswitch.new(0xabc)
        allow(open_vswitch).to receive(:running?).and_return(false, true)
        allow(open_vswitch).to receive(:system)
        open_vswitch
      end

      describe '#run' do
        When { open_vswitch.run }
        Then do
          expect(open_vswitch).to have_received(:system).with(/test-openflowd/)
        end
      end
    end
  end
end
