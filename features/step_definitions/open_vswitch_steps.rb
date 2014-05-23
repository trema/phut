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

Then(/^it should raise "(.*?)"$/) do |error_message|
  @exception.should_not be_nil
  @exception.message.should == error_message
end
