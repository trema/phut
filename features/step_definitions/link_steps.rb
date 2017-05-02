# frozen_string_literal: true

Then(/^a link between "(.*?)" and "(.*?)" should be created$/) do |namea, nameb|
  expect(Phut::Link.find(namea, nameb)).not_to be_nil
end
