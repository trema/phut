# frozen_string_literal: true

Then(/^a vhost named "(.*?)" should be running$/) do |name|
  expect(Phut::Vhost.find_by!(name: name)).to be_running
end
