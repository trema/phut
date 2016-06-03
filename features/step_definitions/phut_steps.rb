# frozen_string_literal: true
When(/^I do phut run "(.*?)"$/) do |config_file|
  @config_file = config_file
  cd('.') do
    run_opts = "-P #{@pid_dir} -L #{@log_dir} -S #{@socket_dir}"
    step %(I run `phut -v run #{run_opts} #{@config_file}`)
  end
end

When(/^I do phut kill "(.*?)"$/) do |name|
  run_opts = "-S #{@socket_dir}"
  step %(I successfully run `phut -v kill #{run_opts} #{name}`)
end

When(/^sleep (\d+)$/) do |time|
  sleep time.to_i
end

Then(/^a vswitch named "(.*?)" should be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists #{Phut::Vswitch.prefix}#{name}")).to be_truthy
end

Then(/^a vswitch named "([^"]*)" \(controller port = (\d+)\) should be running$/) do |name, port_number|
  step %(a vswitch named "#{name}" should be running)
  expect(`sudo ovs-vsctl get-controller #{Phut::Vswitch.prefix}#{name}`.chomp).to eq "tcp:127.0.0.1:#{port_number}"
end

Then(/^a vswitch named "(.*?)" should not be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists #{Phut::Vswitch.prefix}#{name}")).to be_falsey
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  step %(a file named "./tmp/pids/vhost.#{name}.pid" should exist)
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |name_a, name_b|
  expect(Phut::Link.find([name_a, name_b])).not_to be_nil
end

Then(/^a netns named "(.*?)" should be started$/) do |name|
  expect(Phut::Netns.find_by!(name: name)).not_to be_nil
end

Then(/^the IP address of the netns "([^"]*)" should not be set$/) do |name|
  expect(Phut::Netns.find_by!(name: name).ip_address).to be_nil
end

Then(/^the IP address of the netns "([^"]*)" should be "([^"]*)"$/) do |name, ip|
  expect(Phut::Netns.find_by!(name: name).ip_address).to eq ip
end

Then(/^the netmask of the netns "([^"]*)" should be "([^"]*)"$/) do |name, netmask|
  expect(Phut::Netns.find_by!(name: name).netmask).to eq netmask
end

Then(/^the netns "([^"]*)" have the following route:$/) do |name, table|
  netns = Phut::Netns.find_by!(name: name)
  expect(netns.route.net).to eq table.hashes.first['net']
  expect(netns.route.gateway).to eq table.hashes.first['gateway']
end
