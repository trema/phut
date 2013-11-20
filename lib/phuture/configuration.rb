# -*- coding: utf-8 -*-

module Phuture
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch

    def initialize
      @vswitch = []
    end
  end
end
