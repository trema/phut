task :travis => [:spec, :cucumber]

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new

if RUBY_VERSION >= '1.9.0'
  task :travis => :rubocop
  require 'rubocop/rake_task'
  Rubocop::RakeTask.new
end
