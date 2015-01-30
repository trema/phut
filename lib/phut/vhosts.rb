require 'forwardable'

module Phut
  # vhost list.
  class Vhosts
    extend Forwardable

    def_delegator :@list, :[]=
    def_delegator :@list, :fetch
    def_delegator :@list, :size

    def initialize
      @list = {}
    end

    def run_all(links)
      @list.values.each do |each|
        interface = links.find_interface_by_name(each.name)
        fail "No link found for host #{each.name}" if interface.empty?
        each.interface = interface.first
        each.run @list.values
      end
    end

    def stop_all
      @list.values.each(&:stop)
    end
  end
end
