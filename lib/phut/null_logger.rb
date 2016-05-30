# frozen_string_literal: true
require 'logger'

module Phut
  # Null logger
  class NullLogger < Logger
    def initialize(*_args)
      # noop
    end

    def add(*_args, &_block)
      # noop
    end
  end
end
