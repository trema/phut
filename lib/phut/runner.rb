# Base module.
module Phut
  # Runs vswitch and vhost processes and creates virtual links.
  class Runner
    def initialize(configuration)
      @configuration = configuration
    end

    def start
      @configuration.vswitch.values.each(&:run)
      @configuration.vhost.values.each(&:run)
      @configuration.link.each(&:run)
    end

    def stop
      @configuration.vswitch.values.each(&:stop)
      @configuration.vhost.values.each(&:stop)
      @configuration.link.each(&:stop)
    end
  end
end
