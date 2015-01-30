$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rake/clean'

task default: [:openvswitch, :vhost]
task test: [:spec, :cucumber, :quality]
task quality: [:rubocop, :reek, :flog]
task travis: [:spec, 'cucumber:travis', 'coveralls:push']

Dir.glob('tasks/*.rake').each { |each| import each }
