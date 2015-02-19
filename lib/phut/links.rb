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
      @list.map do |each|
        Thread.start { each.run }
      end.each(&:join)
    end

    def stop_all
      @list.map do |each|
        Thread.start { each.stop }
      end.each(&:join)
    end

    def find_by_peers(name_a, name_b)
      @list.find do |each|
        each.name_a == name_a && each.name_b == name_b
      end
    end

    def find_interface_by_name(name)
      @list.each_with_object([]) do |each, list|
        list << each.device_a if name == each.name_a
        list << each.device_b if name == each.name_b
      end
    end
  end
end
