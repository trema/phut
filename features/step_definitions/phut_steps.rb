# frozen_string_literal: true
require 'phut'

# Temporary class
# FIXME: Delete me
class TearDownSyntax < Phut::Syntax
  def vswitch(alias_name = nil, &block)
  end

  def vhost(name = nil, &block)
  end

  def link(name_a, name_b)
  end
end

# Temporary class
# FIXME: Delete me
class TearDownParser
  def parse(file)
    Phut::Configuration.new do |config|
      TearDownSyntax.new(config, @logger).instance_eval IO.read(file), file
      config # .update_connections
    end
  end
end

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

# rubocop:disable LineLength
Then(/^a vswitch named "(.*?)" should be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists #{Phut::Vswitch.prefix}#{name}")).to be_truthy
end
# rubocop:enable LineLength

# rubocop:disable LineLength
Then(/^a vswitch named "([^"]*)" \(controller port = (\d+)\) should be running$/) do |name, port_number|
  step %(a vswitch named "#{name}" should be running)
  expect(`sudo ovs-vsctl get-controller #{Phut::Vswitch.prefix}#{name}`.chomp).to eq "tcp:127.0.0.1:#{port_number}"
end
# rubocop:enable LineLength

# rubocop:disable LineLength
Then(/^a vswitch named "(.*?)" should not be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists #{Phut::Vswitch.prefix}#{name}")).to be_falsey
end
# rubocop:enable LineLength

Then(/^a vhost named "(.*?)" launches$/) do |name|
  step %(a file named "./tmp/pids/vhost.#{name}.pid" should exist)
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |name_a, name_b|
  expect(Phut::Link.find([name_a, name_b])).not_to be_nil
end
