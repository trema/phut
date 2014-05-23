# -*- coding: utf-8 -*-
require 'phut'

Before('@sudo') do
  system 'sudo -v'
  @aruba_timeout_seconds = 5
end

After('@sudo') do
  in_current_dir do
    Dir.glob(File.join(Phut.settings['PID_DIR'], '*.pid')).each do |each|
      pid = IO.read(each).to_i
      system "sudo kill #{pid}"
    end
  end
end
