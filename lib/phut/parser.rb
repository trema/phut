require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(logger = NullLogger.new)
      @config = Configuration.new(logger)
    end

    def parse(dsl)
      Syntax.new(@config).instance_eval dsl
      @config
    end
  end
end
