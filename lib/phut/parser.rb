require 'phut/configuration'
require 'phut/syntax'

module Phut
  # Configuration DSL parser.
  class Parser
    def initialize
      @config = Configuration.new
    end

    def parse(dsl)
      Syntax.new(@config).instance_eval dsl
      @config
    end
  end
end
