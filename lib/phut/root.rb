# encoding: utf-8

# Base module.
module Phut
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..', '..')

  def self.config_root
    if ENV['PHUT_CONFIG_ROOT']
      Pathname.new(ENV['PHUT_CONFIG_ROOT'])
    else
      Pathname.new('.phut')
    end.expand_path
  end

  def self.settings
    Settings.new(config_root)
  end
end
