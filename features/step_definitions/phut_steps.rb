require 'phut'

When(/^I do phut run "(.*?)"$/) do |file_name|
  step %(I successfully run `phut run #{file_name}`)
  @configuration_file = file_name
end

Then(/^a vswitch named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(Phut.settings['PID_DIR'], "open_vswitch.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(Phut.settings['PID_DIR'], "phost.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |peer_a, peer_b|
  in_current_dir do
    configuration = Phut::Parser.new.parse(IO.read(@configuration_file))
    expect(configuration.find_link(peer_a, peer_b)).to be_up
  end
end
