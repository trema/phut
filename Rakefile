# encoding: utf-8

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rake/clean'
require 'bundler/gem_tasks'

task default: :openvswitch
task test: [:spec, :cucumber, :rubocop]
task travis: [:spec, 'cucumber:travis', 'coveralls:push']

Dir.glob('tasks/*.rake').each { |each| import each }
