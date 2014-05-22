# -*- coding: utf-8 -*-
require 'phut/settings'

module Phut
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

    def stop
      pid = IO.read(pid_file)
      system "sudo kill #{pid}"
    end

    private

    def pid_file
      "#{Phut.settings['PID_DIR']}/phost.#{@ip}.pid"
    end

    def executable
      "#{Phut::ROOT}/vendor/phost/src/phost"
    end

    def options
      %W(-p #{Phut.settings['PID_DIR']}
         -l #{Phut.settings['LOG_DIR']}
         -n #{@ip}
         -D)
    end
  end
end
