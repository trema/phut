# Base module.
module Phut
  # Runs vswitch and vhost processes and creates virtual links.
  class Runner
    def initialize(configuration)
      @config = configuration
    end

    def start
      @config.vhost.values.each do |each|
        each.interface = @config.find_interface(each.name)
      end

      @config.link.each(&:run)
      @config.vswitch.values.each(&:run)
      @config.vhost.values.each(&:run)
    end

    def stop
      @config.vswitch.values.each(&:stop)
      @config.vhost.values.each(&:stop)
      @config.link.each(&:stop)
    end
  end
end
