# -*- coding: utf-8 -*-
require 'phuture'

Then(/^a vswitch named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(Phuture.settings['PID_DIR'], 'open_vswitch.0xabc.pid')
    FileTest.exists?(pid_file).should be_true
  end
end
