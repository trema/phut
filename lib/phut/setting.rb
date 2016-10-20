# frozen_string_literal: true
require 'logger'
require 'tmpdir'

# Base module.
module Phut
  # Central configuration repository.
  class Setting
    DEFAULTS = {
      root: File.expand_path(File.join(File.dirname(__FILE__), '..', '..')),
      logger: Logger.new($stderr).tap do |logger|
                logger.formatter = proc { |_sev, _dtm, _name, msg| msg + "\n" }
                logger.level = Logger::INFO
              end,
      pid_dir: Dir.tmpdir,
      log_dir: Dir.tmpdir,
      socket_dir: Dir.tmpdir
    }.freeze

    def initialize
      @options = DEFAULTS.dup
    end

    def root
      @options.fetch :root
    end

    def logger
      @options.fetch :logger
    end

    def pid_dir
      @options.fetch :pid_dir
    end

    def pid_dir=(path)
      raise "No such directory: #{path}" unless FileTest.directory?(path)
      @options[:pid_dir] = File.expand_path(path)
    end

    def log_dir
      @options.fetch :log_dir
    end

    def log_dir=(path)
      raise "No such directory: #{path}" unless FileTest.directory?(path)
      @options[:log_dir] = File.expand_path(path)
    end

    def socket_dir
      @options.fetch :socket_dir
    end

    def socket_dir=(path)
      raise "No such directory: #{path}" unless FileTest.directory?(path)
      @options[:socket_dir] = File.expand_path(path)
    end
  end

  SettingSingleton = Setting.new

  class << self
    # rubocop:disable MethodMissing
    def method_missing(method, *args)
      SettingSingleton.__send__ method, *args
    end
    # rubocop:enable MethodMissing
  end
end
