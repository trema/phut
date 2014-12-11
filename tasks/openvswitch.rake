require 'phut'
require 'tmpdir'

def openvswitch_srcdir
  File.join Phut::ROOT, 'vendor/openvswitch-1.2.2.trema1'
end

desc 'Build Open vSwitch'
task openvswitch: Phut::OpenVswitch::OPENFLOWD

file Phut::OpenVswitch::OPENFLOWD do
  sh 'tar xzf ./vendor/openvswitch-1.2.2.trema1.tar.gz -C vendor'
  cd openvswitch_srcdir do
    sh "./configure --with-rundir=#{Dir.tmpdir}"
    sh 'make'
  end
end

task clean: 'openvswitch:clean'
task 'openvswitch:clean' do
  FileTest.exist?(openvswitch_srcdir) && cd(openvswitch_srcdir) do
    sh 'make clean'
  end
end

CLOBBER.include(openvswitch_srcdir) if FileTest.exists?(openvswitch_srcdir)
