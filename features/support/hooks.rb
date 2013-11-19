After do
  phuture_dir = File.join(File.dirname(__FILE__), '..', '..')
  Dir.glob("#{phuture_dir}/*.pid").each do |each|
    pid = IO.read(each)
    system "sudo kill #{pid}"
  end
end
