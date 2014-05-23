# encoding: utf-8

describe Phut::OpenVswitch do
  describe '.new' do
    context 'with 0xabc' do
      Given(:open_vswitch) do
        open_vswitch = Phut::OpenVswitch.new(0xabc)
        open_vswitch.stub(:running?).and_return(false, true)
        open_vswitch.stub(:system)
        open_vswitch
      end

      describe '#run' do
        When { open_vswitch.run }
        Then do
          open_vswitch.should have_received(:system).with(/test-openflowd/)
        end
      end
    end
  end
end
