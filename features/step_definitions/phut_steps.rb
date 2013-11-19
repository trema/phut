# -*- coding: utf-8 -*-
require 'phuture'

Then(/^a vswitch named "(.*?)" launches$/) do |name|
  pid_file = File.join(Phuture::ROOT, 'open_vswitch.0xabc.pid')
  FileTest.exists?(pid_file).should be_true
end
