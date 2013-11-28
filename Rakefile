require 'coveralls/rake/task'
Coveralls::RakeTask.new

task :default => [:spec, :cucumber]
task :travis => [:spec, 'guard:cucumber', 'coveralls:push']

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'cucumber/rake/task'

task :cucumber => :openvswitch
Cucumber::Rake::Task.new

task 'guard:cucumber' => :openvswitch
Cucumber::Rake::Task.new('guard:cucumber') do |task|
  task.cucumber_opts = '--tags ~@sudo'
end

if RUBY_VERSION >= '1.9.0'
  task :travis => :rubocop
  require 'rubocop/rake_task'
  Rubocop::RakeTask.new
end

ovs_openflowd = './vendor/openvswitch-1.2.2.trema1/tests/test-openflowd'

desc "Build Open vSwitch"
task :openvswitch => ovs_openflowd
file ovs_openflowd do
  sh "tar xzf ./vendor/openvswitch-1.2.2.trema1.tar.gz -C vendor"
  cd './vendor/openvswitch-1.2.2.trema1' do
    sh "./configure --with-rundir=#{ File.dirname __FILE__ }"
    sh "make"
  end
end
