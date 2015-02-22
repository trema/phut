require 'forwardable'

module Phut
  # vswitch list.
  class Vswitches
    extend Forwardable

    def_delegator :@all, :[]=
    def_delegator :@all, :[]
    def_delegator :@all, :values
    def_delegator :@all, :fetch
    def_delegator :@all, :size

    def initialize
      @all = {}
    end

    # This code smells of :reek:FeatureEnvy
    def run_all
      @all.values.each(&:run)
    end

    def stop_all
      @all.values.select(&:running?).each(&:stop)
    end
  end
end
