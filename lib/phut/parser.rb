# -*- coding: utf-8 -*-
require 'phut/configuration'
require 'phut/syntax'

module Phut
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
