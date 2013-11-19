# -*- coding: utf-8 -*-
require 'phuture'

After do
  Dir.glob("#{Phuture::ROOT}/*.pid").each do |each|
    pid = IO.read(each)
    system "sudo kill #{pid}"
  end
end
