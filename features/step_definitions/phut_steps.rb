# frozen_string_literal: true

When(/^I do phut run "(.*?)"$/) do |config_file|
  run_opts = "-P #{@pid_dir} -L #{@log_dir} -S #{@socket_dir}"
  step %(I run `phut -v run #{run_opts} #{config_file}`)
end

When(/^I do phut kill "(.*?)"$/) do |name|
  run_opts = "-S #{@socket_dir}"
  step %(I successfully run `phut -v kill #{run_opts} #{name}`)
end

When(/^sleep (\d+)$/) do |second|
  step "I successfully run `sleep #{second}`"
end
