# -*- coding: utf-8 -*-

module Phuture
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost

    def initialize
      @vswitch = []
      @vhost = []
    end
  end
end
