When(/^I successfully run Open vSwitch with dpid = "(.*?)"$/) do |dpid|
  in_current_dir do
    Phut::OpenVswitch.new(dpid.hex).run
  end
end

When(/^I run Open vSwitch with dpid = "(.*?)"$/) do |dpid|
  in_current_dir do
    begin
      Phut::OpenVswitch.new(dpid.hex).run
    rescue => exception
      @exception = exception
    end
  end
end

When(/^I successfully shutdown Open vSwitch with dpid = "(.*?)"$/) do |dpid|
  in_current_dir do
    Phut::OpenVswitch.new(dpid.hex).shutdown
  end
end

When(/^I shutdown Open vSwitch with dpid = "(.*?)"$/) do |dpid|
  in_current_dir do
    begin
      Phut::OpenVswitch.new(dpid.hex).shutdown
    rescue => exception
      @exception = exception
    end
  end
end

Then(/^it should raise "(.*?)"$/) do |error_message|
  expect(@exception).not_to be_nil
  expect(@exception.message).to eq(error_message)
end
