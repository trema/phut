# Base module.
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

  def self.run(config_file, &block)
    dsl = config_file ? IO.read(config_file) : ''
    config = Phut::Parser.new.parse(dsl)
    runner = Phut::Runner.new(config)
    begin
      runner.start
      block.call
    ensure
      runner.stop
    end
  end
end
