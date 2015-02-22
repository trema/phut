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

Before('@shell') do
  fail 'sudo authentication failed' unless system 'sudo -v'
end

After('@sudo') do
  in_current_dir do
    Phut.pid_dir = @pid_dir
    Phut.log_dir = @log_dir
    Phut.socket_dir = @socket_dir
    Phut::Parser.new.parse(@config_file).stop
  end
end

After('@shell') do
  in_current_dir do
    Dir.glob(File.join(Dir.getwd, '*.pid')).each do |each|
      pid = IO.read(each).to_i
      run "sudo kill #{pid}"
    end
  end
end
