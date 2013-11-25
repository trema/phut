$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'bundler/gem_tasks'
require 'phuture'

task :default => :openvswitch
task :test => [:spec, :cucumber]
task :travis => [:spec, 'guard:cucumber']

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

require 'tmpdir'
desc 'Build Open vSwitch'
task :openvswitch => ovs_openflowd
file ovs_openflowd do
  sh 'tar xzf ./vendor/openvswitch-1.2.2.trema1.tar.gz -C vendor'
  cd './vendor/openvswitch-1.2.2.trema1' do
    sh "./configure --with-rundir=#{Dir.tmpdir}"
    sh 'make'
  end
end

def phost_src
  File.join Phuture::ROOT, 'vendor', 'phost', 'src'
end

def phost_objects
  FileList[File.join(phost_src, '*.o')]
end

def phost_vendor_binary
  File.join phost_src, 'phost'
end

def phost_cli_vendor_binary
  File.join phost_src, 'cli'
end

desc 'Build vhost executables'
task :vhost => [phost_vendor_binary, phost_cli_vendor_binary]

file phost_vendor_binary do
  cd phost_src do
    sh 'make'
  end
end

file phost_cli_vendor_binary do
  cd phost_src do
    sh 'make'
  end
end
