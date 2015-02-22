require 'forwardable'

module Phut
  # Virtual link list.
  class Links
    extend Forwardable

    def_delegator :@all, :<<
    def_delegator :@all, :size
    def_delegator :@all, :find
    def_delegator :@all, :select

    def initialize
      @all = []
    end

    def run_all
      @all.map(&:run)
    end

    def stop_all
      @all.map(&:stop)
    end
  end
end
