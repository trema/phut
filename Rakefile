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
task vhost: [phost_vendor_binary, phost_cli_vendor_binary]

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

Dir.glob('tasks/*.rake').each { |each| import each }
