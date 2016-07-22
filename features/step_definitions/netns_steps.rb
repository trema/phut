# frozen_string_literal: true
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

Then(/^the VLAN of the netns "([^"]*)" should be "([^"]*)"$/) do |name, vlan|
  expect(Phut::Netns.find_by!(name: name).vlan).to eq vlan
end
