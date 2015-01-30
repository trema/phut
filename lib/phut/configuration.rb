require 'phut/links'
require 'phut/vhosts'
require 'phut/vswitches'

module Phut
  # Parsed DSL data.
  class Configuration
    attr_reader :vswitch
    attr_reader :vhost
    attr_reader :links

    def initialize
      @vswitch = Vswitches.new
      @vhost = Vhosts.new
      @links = Links.new
    end

    def run
      @links.run_all
      @vswitch.run_all(@links)
      @vhost.run_all(@links)
    end

    def stop
      @vswitch.stop_all
      @vhost.stop_all
      @links.stop_all
    end
  end
end
