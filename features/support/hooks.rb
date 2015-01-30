require 'phut'

Before do
  @aruba_timeout_seconds = 10
end

After('@sudo') do
  in_current_dir do
    Phut::Parser.new.parse(IO.read(@config_file)).stop if @config_file
  end
end

After('@shell') do
  in_current_dir do
    Dir.glob(File.join(Phut.settings['PID_DIR'], '*.pid')).each do |each|
      pid = IO.read(each).to_i
      run "sudo kill #{pid}"
    end
  end
end
