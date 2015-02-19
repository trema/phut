require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(logger = NullLogger.new)
      @config = Configuration.new(logger)
    end

    def parse(file)
      Syntax.new(@config).instance_eval IO.read(file), file
      @config
    end
  end
end
