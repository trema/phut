# -*- coding: utf-8 -*-

# Base module.
module Phuture
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')

  def self.config_root
    if ENV['PHUTURE_CONFIG_ROOT']
      Pathname.new(ENV['PHUTURE_CONFIG_ROOT'])
    else
      Pathname.new('.phuture')
    end.expand_path
  end

  def self.settings
    @settings ||= Settings.new(config_root)
  end
end

require 'phuture/open_vswitch'
require 'phuture/parser'
require 'phuture/runner'
require 'phuture/settings'
require 'phuture/version'
