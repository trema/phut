require 'forwardable'

module Phut
  # vhost list.
  class Vhosts
    extend Forwardable

    def_delegator :@all, :[]=
    def_delegator :@all, :values
    def_delegator :@all, :fetch
    def_delegator :@all, :size

    def initialize
      @all = {}
    end

    def run_all
      all_hosts = @all.values
      all_hosts.each { |each| each.run all_hosts }
    end

    def stop_all
      @all.values.map(&:stop)
    end
  end
end
