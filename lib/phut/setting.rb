require 'tmpdir'

# Base module.
module Phut
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..', '..')

  # Central configuration repository.
  class Setting
    DEFAULTS = {
      pid_dir: Dir.tmpdir,
      log_dir: Dir.tmpdir,
      socket_dir: Dir.tmpdir
    }

    def initialize
      @options = DEFAULTS.dup
    end

    def pid_dir
      @options.fetch :pid_dir
    end

    def pid_dir=(path)
      @options[:pid_dir] = File.expand_path(path)
    end

    def log_dir
      @options.fetch :log_dir
    end

    def log_dir=(path)
      @options[:log_dir] = File.expand_path(path)
    end

    def socket_dir
      @options.fetch :socket_dir
    end

    def socket_dir=(path)
      @options[:socket_dir] = File.expand_path(path)
    end
  end

  SettingSingleton = Setting.new

  class << self
    def pid_dir
      SettingSingleton.pid_dir
    end

    def pid_dir=(path)
      SettingSingleton.pid_dir = path
    end

    def log_dir
      SettingSingleton.log_dir
    end

    def log_dir=(path)
      SettingSingleton.log_dir = path
    end

    def socket_dir
      SettingSingleton.socket_dir
    end

    def socket_dir=(path)
      SettingSingleton.socket_dir = path
    end
  end
end
