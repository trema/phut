Then(/^a vswitch named "(.*?)" launches$/) do |name|
  pid_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  pid_file = File.join(pid_dir, 'open_vswitch.0xabc.pid')
  FileTest.exists?(pid_file).should be_true
end
