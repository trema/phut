require 'phut'

Before do
  @pid_dir = '.'
  @log_dir = '.'
  @socket_dir = '.'
end

Before('@sudo') do
  fail 'sudo authentication failed' unless system 'sudo -v'
  @aruba_timeout_seconds = 10
end

After('@sudo') do
  Aruba.configure do |config|
    Dir.chdir(config.working_directory) do
      Phut.pid_dir = @pid_dir
      Phut.log_dir = @log_dir
      Phut.socket_dir = @socket_dir
      Phut::Parser.new.parse(@config_file).stop
    end
  end
end

Before('@shell') do
  fail 'sudo authentication failed' unless system 'sudo -v'
end

After('@shell') do
  `sudo ovs-vsctl list-br`.split("\n").each do |each|
    run "sudo ovs-vsctl del-br #{each}"
  end
end
