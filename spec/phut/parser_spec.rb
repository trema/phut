require 'phut'
require 'stringio'

describe Phut::Parser do
  describe '#parse' do
    Given { allow(IO).to receive(:read).with('CONFIG_FILE').and_return(string) }
    Given(:config) { Phut::Parser.new.parse 'CONFIG_FILE' }

    context "with 'vswitch { dpid '0xabc' }'" do
      When(:string) { "vswitch { dpid '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('0xabc').datapath_id == 0xabc }
        Then { vswitch.fetch('0xabc').dpid == 0xabc }
      end
    end

    context "with 'vswitch { datapath_id '0xabc' }" do
      When(:string) { "vswitch { datapath_id '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('0xabc').dpid == 0xabc }
        Then { vswitch.fetch('0xabc').datapath_id == 0xabc }
      end
    end

    context "with 'vswitch('my_controller') { dpid '0xabc' }'" do
      When(:string) { "vswitch('my_controller') { dpid '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('my_controller').dpid == 0xabc }
        Then { vswitch.fetch('my_controller').datapath_id == 0xabc }
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
        When(:vhost) { config.vhost }

        Then { vhost.size == 2 }
        Then { vhost.fetch('192.168.0.1').ip == '192.168.0.1' }
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
        When(:vhost) { config.vhost }

        Then { vhost.size == 2 }
        Then { vhost.fetch('host1').ip == '192.168.0.1' }
      end
    end
  end
end
