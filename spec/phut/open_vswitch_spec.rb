describe Phut::OpenVswitch do
  describe '.new' do
    context 'with 0xabc' do
      Given(:vswitch) do
        Phut::OpenVswitch.new(0xabc).tap do |vswitch|
          allow(vswitch).to receive(:running?).and_return(false, true)
          allow(vswitch).to receive(:sh)
        end
      end

      describe '#run' do
        When { vswitch.run }
        Then do
          expect(vswitch).to have_received(:sh).with(/test-openflowd/,
                                                     verbose: false)
        end
      end
    end
  end
end
