require 'phut'

Before do
  @aruba_timeout_seconds = 10
end

Before('@sudo') do
  @pid_dir = '.'
  @log_dir = '.'
  @socket_dir = '.'
end

After('@sudo') do
  in_current_dir do
    Phut.pid_dir = '.'
    Phut.log_dir = '.'
    Phut.socket_dir = '.'
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
