# -*- coding: utf-8 -*-
require 'phut'

Before('@sudo') do
  system 'sudo -v'
  @aruba_timeout_seconds = 5
end

After('@sudo') do
  in_current_dir do
    configuration = Phut::Parser.new.parse(IO.read(@configuration_file))
    Phut::Runner.new(configuration).stop
  end
end
