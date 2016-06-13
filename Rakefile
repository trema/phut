# frozen_string_literal: true
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rake/clean'

RELISH_PROJECT = 'trema/phut'

task default: :test
task test: [:spec, :cucumber, :quality]
task travis: ['cucumber:travis', :quality]
task quality: [:rubocop, :reek, :flog, :flay]

Dir.glob('tasks/*.rake').each { |each| import each }
