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
      value = @db[key]
      key =~ /.+_DIR/ && !value.nil? ? File.expand_path(value) : value
    end

    private

    def load_config
      if config_file.exist?
        Hash[config_file.read.scan(/^(.+): ['"]?(.+?)['"]?$/)]
      else
        {}
      end
    end

    def config_file
      Pathname.new(@root).join('config')
    end
  end
end
