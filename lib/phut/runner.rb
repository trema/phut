# Base module.
module Phut
  # Runs vswitch and vhost processes and creates virtual links.
  class Runner
    def initialize(configuration)
      @config = configuration
    end

    def start
      @config.link.each(&:run)

      @config.vswitch.values.each do |each|
        each.run
        each.interfaces = @config.find_interfaces(each.name)
      end

      @config.vhost.values.each do |each|
        each.interface = @config.find_interface(each.name)
        each.run
        each.set_ip_and_mac_address
        each.add_arp_entries @config.vhost.values
      end
    end

    def stop
      @config.vswitch.values.each(&:stop)
      @config.vhost.values.each(&:stop)
      @config.link.each(&:stop)
    end
  end
end
