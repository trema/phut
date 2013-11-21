# -*- coding: utf-8 -*-
require 'phuture'

Before('@sudo') do
  system 'sudo -v'
end

After('@sudo') do
  in_current_dir do
    configuration = Phuture::Parser.new.parse(IO.read(@configuration_file))
    Phuture::Runner.new(configuration).stop
  end
end
