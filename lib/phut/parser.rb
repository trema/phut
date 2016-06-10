# frozen_string_literal: true
require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(file, logger = NullLogger.new)
      @file = file
      @logger = logger
    end

    def parse
      Configuration.new do |config|
        Syntax.new(config).instance_eval IO.read(@file), @file
      end
    end
  end
end
