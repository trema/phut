require 'phut'

describe Phut::Parser do
  describe '#parse' do
    Given(:config) { Phut::Parser.new.parse string }

    context "with 'vswitch { dpid '0xabc' }'" do
      When(:string) { "vswitch { dpid '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('0xabc').datapath_id == '0xabc' }
        Then { vswitch.fetch('0xabc').dpid == '0xabc' }
      end
    end

    context "with 'vswitch { datapath_id '0xabc' }" do
      When(:string) { "vswitch { datapath_id '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('0xabc').dpid == '0xabc' }
        Then { vswitch.fetch('0xabc').datapath_id == '0xabc' }
      end
    end

    context "with 'vswitch('my_controller') { dpid '0xabc' }'" do
      When(:string) { "vswitch('my_controller') { dpid '0xabc' }" }

      describe '#vswitch' do
        When(:vswitch) { config.vswitch }

        Then { vswitch.size == 1 }
        Then { vswitch.fetch('my_controller').dpid == '0xabc' }
        Then { vswitch.fetch('my_controller').datapath_id == '0xabc' }
      end
    end

    context "with 'vhost { ip '192.168.0.1' }'" do
      When(:string) { "vhost { ip '192.168.0.1' }" }

      describe '#vhost' do
        When(:vhost) { config.vhost }

        Then { vhost.size == 1 }
        Then { vhost.fetch('192.168.0.1').ip == '192.168.0.1' }
      end
    end

    context "with 'vhost('host1') { ip '192.168.0.1' }'" do
      When(:string) { "vhost('host1') { ip '192.168.0.1' }" }

      describe '#vhost' do
        When(:vhost) { config.vhost }

        Then { vhost.size == 1 }
        Then { vhost.fetch('host1').ip == '192.168.0.1' }
      end
    end
  end
end
