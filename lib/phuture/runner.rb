# -*- coding: utf-8 -*-

module Phuture
  # Runs vswitch and vhost processes and creates virtual links.
  class Runner
    def initialize(configuration)
      @configuration = configuration
    end

    def start
      @configuration.vswitch.each do |each|
        each.run
      end
      @configuration.vhost.each do |each|
        each.run
      end
      @configuration.link.each do |each|
        each.run
      end
    end

    def stop
      @configuration.vswitch.each do |each|
        each.stop
      end
      @configuration.vhost.each do |each|
        each.stop
      end
      @configuration.link.each do |each|
        each.stop
      end
    end
  end
end
