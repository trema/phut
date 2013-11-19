# -*- coding: utf-8 -*-

# Base module.
module Phuture
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')
end

require 'phuture/open_vswitch'
require 'phuture/setting'
require 'phuture/version'
