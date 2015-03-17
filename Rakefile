$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rake/clean'

task default: :test
task test: [:spec, :cucumber, :quality]
task quality: [:rubocop, :reek, :flog]
task travis: [:spec, 'cucumber:travis', :quality]

Dir.glob('tasks/*.rake').each { |each| import each }
