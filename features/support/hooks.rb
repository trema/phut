# frozen_string_literal: true

require 'phut'

Before do
  Aruba.configure do |config|
    Dir.chdir(config.working_directory) do
      @log_dir = './log'
      @pid_dir = './tmp/pids'
      @socket_dir = './tmp/sockets'

      FileUtils.mkdir_p(@log_dir) unless File.exist?(@log_dir)
      FileUtils.mkdir_p(@pid_dir) unless File.exist?(@pid_dir)
      FileUtils.mkdir_p(@socket_dir) unless File.exist?(@socket_dir)

      Phut.pid_dir = @pid_dir
      Phut.log_dir = @log_dir
      Phut.socket_dir = @socket_dir
    end
  end
end

Before('@sudo') do
  raise 'sudo authentication failed' unless system 'sudo -v'
  @aruba_timeout_seconds = 10
end

After('@sudo') do
  Aruba.configure do |config|
    Dir.chdir(config.working_directory) do
      Phut.pid_dir = @pid_dir
      Phut.log_dir = @log_dir
      Phut.socket_dir = @socket_dir

      Phut::Vswitch.destroy_all
      Phut::Vhost.destroy_all
      Phut::Netns.destroy_all
      Phut::Link.destroy_all
    end
  end
end
