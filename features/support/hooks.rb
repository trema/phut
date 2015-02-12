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
    Phut.options = {
      pid_dir: @pid_dir,
      log_dir: @log_dir,
      socket_dir: @socket_dir
    }
    Phut::Parser.new.parse(IO.read(@config_file)).stop
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
