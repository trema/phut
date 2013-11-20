# -*- coding: utf-8 -*-
require 'phuture/settings'

module Phuture
  # An interface class to phost emulation utility program.
  class Phost
    attr_reader :ip

    def initialize(ip_address)
      @ip = ip_address
    end

    def run
      system "sudo #{executable} #{options.join ' '}"
      sleep 1
    end

    private

    def executable
      "#{Phuture::ROOT}/vendor/phost/src/phost"
    end

    def options
      %W(-p #{Phuture.settings['PID_DIR']}
         -l #{Phuture.settings['LOG_DIR']}
         -n #{@ip}
         -D)
    end
  end
end
