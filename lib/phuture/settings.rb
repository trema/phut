# -*- coding: utf-8 -*-

# Base module.
module Phuture
  # Central configuration repository.
  class Settings
    def initialize
      @root = '.phuture'
      @db = load_config
    end

    def [](key)
      value = @db[key]
      key =~ /.+_DIR/ ? File.expand_path(value) : value
    end

    private

    def load_config
      Hash[config_file.read.scan(/^(.+): ['"]?(.+?)['"]?$/)]
    end

    def config_file
      Pathname.new(@root).join('config')
    end
  end
end
