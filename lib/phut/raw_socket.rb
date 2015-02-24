require 'socket'

module Phut
  # raw socket
  class RawSocket
    ETH_P_ALL = 0x0300
    SIOCGIFINDEX = 0x8933

    def initialize(interface)
      @socket =
        Socket.new(Socket::PF_PACKET, Socket::SOCK_RAW, ETH_P_ALL).tap do |sock|
          ifreq = [interface].pack('a32')
          sock.ioctl SIOCGIFINDEX, ifreq
          sock.bind([Socket::AF_PACKET].pack('s').tap do |sll|
                      sll << ([ETH_P_ALL].pack 's')
                      sll << ifreq[16..20]
                      sll << ("\x00" * 12)
                    end)
        end
    end

    def method_missing(method, *args)
      @socket.__send__ method, *args
    end
  end
end
