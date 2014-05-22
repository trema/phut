# encoding: utf-8

require 'phuture'

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
