# -*- coding: utf-8 -*-
require 'phuture/configuration'
require 'phuture/syntax'

module Phuture
  # Configuration DSL parser.
  class Parser
    def initialize
      @configuration = Configuration.new
    end

    def parse(dsl)
      Syntax.new(@configuration).instance_eval dsl
      @configuration
    end
  end
end
