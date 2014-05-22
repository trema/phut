# encoding: utf-8

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'phuture'
require 'bundler/gem_tasks'
require 'coveralls/rake/task'
Coveralls::RakeTask.new

task default: :openvswitch
task test: [:spec, :cucumber]
task travis: [:spec, 'cucumber:travis', 'coveralls:push']

ovs_openflowd = './vendor/openvswitch-1.2.2.trema1/tests/test-openflowd'

require 'tmpdir'
desc 'Build Open vSwitch'
task openvswitch: ovs_openflowd
file ovs_openflowd do
  sh 'tar xzf ./vendor/openvswitch-1.2.2.trema1.tar.gz -C vendor'
  cd './vendor/openvswitch-1.2.2.trema1' do
    sh "./configure --with-rundir=#{Dir.tmpdir}"
    sh 'make'
  end
end

Dir.glob('tasks/*.rake').each { |each| import each }
