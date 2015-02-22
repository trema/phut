require 'forwardable'

module Phut
  # vswitch list.
  class Vswitches
    extend Forwardable

    def_delegator :@all, :[]=
    def_delegator :@all, :[]
    def_delegator :@all, :fetch
    def_delegator :@all, :size

    def initialize
      @all = {}
    end

    # This code smells of :reek:FeatureEnvy
    def run_all(links)
      @all.values.each do |each|
        each.interfaces = links.find_interfaces_by_name(each.name)
        each.run
      end
    end

    def stop_all
      @all.values.select(&:running?).each(&:stop)
    end
  end
end
