# frozen_string_literal: true
Then(/^a vswitch named "(.*?)" should be running$/) do |name|
  expect(Phut::Vswitch.find_by!(name: name)).to be_running
end

Then(/^a vswitch named "(.*?)" should not be running$/) do |name|
  expect(Phut::Vswitch.find_by(name: name)).to be_nil
end

Then(/^a vswitch named "([^"]*)" \(controller port = (\d+)\) should be running$/) do |name, port_number|
  expect(Phut::Vswitch.find_by!(name: name).tcp_port).to eq port_number.to_i
end
