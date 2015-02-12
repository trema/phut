require 'tmpdir'

# Base module.
module Phut
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..', '..')

  # Central configuration repository.
  class Settings
    DEFAULTS = {
      verbose: false,
      pid_dir: Dir.tmpdir,
      log_dir: Dir.tmpdir,
      socket_dir: Dir.tmpdir
    }

    def self.options=(user_opts)
      expanded = user_opts.each_with_object({}) do |(key, val), tmp|
        tmp[key] = /_dir$/ =~ key ? File.expand_path(val) : val
      end
      options.replace DEFAULTS.merge(expanded)
    end

    def self.options
      @options ||= DEFAULTS.dup
    end

    def [](key)
      self.class.options.fetch(key)
    end
  end

  def self.options
    Settings.options
  end

  def self.options=(options)
    Settings.options = options
  end

  def self.settings
    Settings.new
  end
end
