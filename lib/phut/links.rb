require 'forwardable'

module Phut
  # Virtual link list.
  class Links
    extend Forwardable

    def_delegator :@all, :<<
    def_delegator :@all, :size

    def initialize
      @all = []
    end

    def run_all
      @all.map(&:run)
    end

    def stop_all
      @all.map(&:stop)
    end

    def find_by_peers(name_a, name_b)
      @all.find do |each|
        each.name_a == name_a && each.name_b == name_b
      end
    end

    def find_interfaces_by_name(name)
      @all.each_with_object([]) do |each, interfaces|
        interfaces << each.device_a if name == each.name_a
        interfaces << each.device_b if name == each.name_b
      end
    end
  end
end
