module Phut
  # Network virtual link.
  class VirtualLink
    attr_reader :peer_a
    attr_reader :peer_b
    attr_reader :name_a
    attr_reader :name_b

    def initialize(peer_a, name_a, peer_b, name_b)
      @peer_a = peer_a
      @name_a = name_a
      @peer_b = peer_b
      @name_b = name_b
    end

    def run
      add
      up
    end

    def stop
      delete
    end

    # @todo Use ifconfig command.
    def up?
      true
    end

    private

    def add
      system "sudo ip link add name #{@name_a} type veth peer name #{@name_b}"
      system "sudo /sbin/sysctl -w net.ipv6.conf.#{@name_a}.disable_ipv6=1"
      system "sudo /sbin/sysctl -w net.ipv6.conf.#{@name_b}.disable_ipv6=1"
    end

    def delete
      system "sudo ip link delete #{@name_a} 2>/dev/null"
    end

    def up
      system "sudo /sbin/ifconfig #{@name_a} up"
      system "sudo /sbin/ifconfig #{@name_b} up"
    end
  end
end
