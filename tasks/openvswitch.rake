# encoding: utf-8

require 'phut'
require 'tmpdir'

def ovs_openflowd
  File.join(Phut::ROOT,
            'vendor/openvswitch-1.2.2.trema1/tests/test-openflowd')
end

desc 'Build Open vSwitch'
task openvswitch: ovs_openflowd

file ovs_openflowd do
  sh 'tar xzf ./vendor/openvswitch-1.2.2.trema1.tar.gz -C vendor'
  cd './vendor/openvswitch-1.2.2.trema1' do
    sh "./configure --with-rundir=#{Dir.tmpdir}"
    sh 'make'
  end
end
