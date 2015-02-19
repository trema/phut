require 'phut'

When(/^I do phut run "(.*?)"$/) do |file_name|
  @config_file = file_name
  run_opts = "-p #{@pid_dir} -l #{@log_dir} -s #{@socket_dir}"
  step %(I successfully run `phut -v run #{run_opts} #{@config_file}`)
end

Then(/^a vswitch named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(File.expand_path(@pid_dir), "open_vswitch.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(File.expand_path(@pid_dir), "phost.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |name_a, name_b|
  in_current_dir do
    config = Phut::Parser.new.parse(@config_file)
    expect(config.links.find_by_peers(name_a, name_b)).to be_up
  end
end
