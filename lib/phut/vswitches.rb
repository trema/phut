require 'forwardable'

module Phut
  # vswitch list.
  class Vswitches
    extend Forwardable

    def_delegator :@list, :[]=
    def_delegator :@list, :[]
    def_delegator :@list, :fetch
    def_delegator :@list, :size

    def initialize
      @list = {}
    end

    def run_all(links)
      @list.values.each do |each|
        each.interfaces = links.find_interface_by_name(each.name)
        each.run
      end
    end

    def stop_all
      @list.values.each do |each|
        each.stop if each.running?
      end
    end
  end
end
