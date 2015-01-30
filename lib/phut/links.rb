require 'forwardable'

module Phut
  # Virtual link list.
  class Links
    extend Forwardable

    def_delegator :@list, :<<
    def_delegator :@list, :size

    def initialize
      @list = []
    end

    def run_all
      @list.each(&:run)
    end

    def stop_all
      @list.each(&:stop)
    end

    def find_by_peers(peer_a, peer_b)
      @list.find do |each|
        each.peer_a == peer_a && each.peer_b == peer_b
      end
    end

    def find_interface_by_name(name)
      @list.each_with_object([]) do |each, list|
        list << each.name_a if name == each.peer_a
        list << each.name_b if name == each.peer_b
      end
    end
  end
end
