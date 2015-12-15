require 'phut'
require 'stringio'

describe Phut::Parser do
  describe '#parse' do
    Given do
      allow(IO).to receive(:read).with('CONFIGURATION_FILE').and_return(string)
    end
    Given(:configuration) { Phut::Parser.new.parse 'CONFIGURATION_FILE' }

    context "with 'vswitch { dpid '0xabc' }'" do
      When(:string) { "vswitch { dpid '0xabc' }" }

      describe '#vswitch' do
        Then { configuration.fetch('0xabc').datapath_id == 0xabc }
        Then { configuration.fetch('0xabc').dpid == 0xabc }
      end
    end

    context "with 'vswitch { datapath_id '0xabc' }" do
      When(:string) { "vswitch { datapath_id '0xabc' }" }

      describe '#vswitch' do
        Then { configuration.fetch('0xabc').dpid == 0xabc }
        Then { configuration.fetch('0xabc').datapath_id == 0xabc }
      end
    end

    context "with 'vswitch('my_controller') { dpid '0xabc' }'" do
      When(:string) { "vswitch('my_controller') { dpid '0xabc' }" }

      describe '#vswitch' do
        Then { configuration.fetch('my_controller').dpid == 0xabc }
        Then { configuration.fetch('my_controller').datapath_id == 0xabc }
      end
    end

    context "with 'vhost { ip '192.168.0.1' }' ..." do
      When(:string) do
        <<-CONFIGURATION
        vhost { ip '192.168.0.1' }
        vhost { ip '192.168.0.2' }
        link '192.168.0.1', '192.168.0.2'
CONFIGURATION
      end

      describe '#vhost' do
        Then { configuration.fetch('192.168.0.1').ip_address == '192.168.0.1' }
      end
    end

    context "with 'vhost('host1') { ip '192.168.0.1' }' ..." do
      When(:string) do
        <<-CONFIGURATION
        vhost('host1') { ip '192.168.0.1' }
        vhost('host2') { ip '192.168.0.2' }
        link 'host1', 'host2'
CONFIGURATION
      end

      describe '#vhost' do
        Then { configuration.fetch('host1').ip_address == '192.168.0.1' }
      end
    end
  end
end
