# -*- coding: utf-8 -*-

# Base module.
module Phuture
  # Central configuration repository.
  class Settings
    def initialize(root)
      @root = root
      @db = load_config
    end

    def [](key)
      value = default_values.merge(@db)[key]
      key =~ /.+_DIR/ && !value.nil? ? File.expand_path(value) : value
    end

    private

    def default_values
      {
        'PID_DIR' => Pathname(@root).expand_path.to_s,
        'LOG_DIR' => Pathname(@root).expand_path.to_s,
        'SOCKET_DIR' => Pathname(@root).expand_path.to_s,
      }
    end

    def load_config
      if config_file.exist?
        Hash[config_file.read.scan(/^(.+): ['"]?(.+?)['"]?$/)]
      else
        default_values
      end
    end

    def config_file
      Pathname.new(@root).join('config')
    end
  end
end
