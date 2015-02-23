begin
  require 'bundler/gem_tasks'
rescue LoadError
  task :build do
    $stderr.puts 'Bundler is disabled'
  end
  task :install do
    $stderr.puts 'Bundler is disabled'
  end
  task :release do
    $stderr.puts 'Bundler is disabled'
  end
end
