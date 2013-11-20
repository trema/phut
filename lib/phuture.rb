# -*- coding: utf-8 -*-

# Base module.
module Phuture
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')

  def self.settings
    @settings ||= Settings.new
  end
end

require 'phuture/open_vswitch'
require 'phuture/parser'
require 'phuture/settings'
require 'phuture/version'
