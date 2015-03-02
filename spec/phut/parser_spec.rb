require 'phut'
require 'stringio'

describe Phut::Parser do
  describe '#parse' do
    Given { allow(IO).to receive(:read).with('CONFIG_FILE').and_return(string) }
    Given(:config) { Phut::Parser.new.parse 'CONFIG_FILE' }

    context "with 'vswitch { dpid '0xabc' }'" do
      When(:string) { "vswitch { dpid '0xabc' }" }

      describe '#vswitch' do
        Then { config.vswitches.size == 1 }
        Then { config.fetch('0xabc').datapath_id == 0xabc }
        Then { config.fetch('0xabc').dpid == 0xabc }
      end
    end

    context "with 'vswitch { datapath_id '0xabc' }" do
      When(:string) { "vswitch { datapath_id '0xabc' }" }

      describe '#vswitch' do
        Then { config.vswitches.size == 1 }
        Then { config.fetch('0xabc').dpid == 0xabc }
        Then { config.fetch('0xabc').datapath_id == 0xabc }
      end
    end

    context "with 'vswitch('my_controller') { dpid '0xabc' }'" do
      When(:string) { "vswitch('my_controller') { dpid '0xabc' }" }

      describe '#vswitch' do
        Then { config.vswitches.size == 1 }
        Then { config.fetch('my_controller').dpid == 0xabc }
        Then { config.fetch('my_controller').datapath_id == 0xabc }
      end
    end

    context "with 'vhost { ip '192.168.0.1' }' ..." do
      When(:string) do
        <<-CONFIG
        vhost { ip '192.168.0.1' }
        vhost { ip '192.168.0.2' }
        link '192.168.0.1', '192.168.0.2'
CONFIG
      end

      describe '#vhost' do
        Then { config.vhosts.size == 2 }
        Then { config.fetch('192.168.0.1').ip_address == '192.168.0.1' }
      end
    end

    context "with 'vhost('host1') { ip '192.168.0.1' }' ..." do
      When(:string) do
        <<-CONFIG
        vhost('host1') { ip '192.168.0.1' }
        vhost('host2') { ip '192.168.0.2' }
        link 'host1', 'host2'
CONFIG
      end

      describe '#vhost' do
        Then { config.vhosts.size == 2 }
        Then { config.fetch('host1').ip_address == '192.168.0.1' }
      end
    end
  end
end
