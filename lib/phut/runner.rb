# -*- coding: utf-8 -*-

module Phut
  # Runs vswitch and vhost processes and creates virtual links.
  class Runner
    def initialize(configuration)
      @configuration = configuration
    end

    def start
      @configuration.vswitch.each(&:run)
      @configuration.vhost.each(&:run)
      @configuration.link.each(&:run)
    end

    def stop
      @configuration.vswitch.each(&:stop)
      @configuration.vhost.each(&:stop)
      @configuration.link.each(&:stop)
    end
  end
end
