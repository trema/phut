# encoding: utf-8

begin
  require 'cucumber/rake/task'

  task cucumber: :openvswitch
  Cucumber::Rake::Task.new

  task 'cucumber:travis' => :openvswitch
  Cucumber::Rake::Task.new('cucumber:travis') do |task|
    task.cucumber_opts = '--tags ~@sudo'
  end
rescue LoadError
  task :cucumber do
    $stderr.puts 'Cucumber is disabled'
  end
  task 'cucumber:travis' do
    $stderr.puts 'Cucumber is disabled'
  end
end
