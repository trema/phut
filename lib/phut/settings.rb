require 'tmpdir'

# Base module.
module Phut
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
        'PID_DIR' => Dir.tmpdir,
        'LOG_DIR' => Dir.tmpdir,
        'SOCKET_DIR' => Dir.tmpdir
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
