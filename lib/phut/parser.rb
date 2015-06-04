require 'phut/configuration'
require 'phut/null_logger'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize(logger = NullLogger.new)
      @logger = logger
    end

    def parse(file)
      Configuration.new(@logger).tap do |configuration|
        Syntax.new(configuration).instance_eval IO.read(file), file
        configuration.update_connections
      end
    end
  end
end
