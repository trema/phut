# -*- coding: utf-8 -*-
require 'phuture'

Then(/^a vswitch named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(Phuture.settings['PID_DIR'], 'open_vswitch.0xabc.pid')
    step %{a file named "#{pid_file}" should exist}
  end
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(Phuture.settings['PID_DIR'], "phost.#{name}.pid")
    step %{a file named "#{pid_file}" should exist}
  end
end
