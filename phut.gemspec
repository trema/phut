# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phut/version'

Gem::Specification.new do | gem |
  gem.name = 'phut'
  gem.version = Phut::VERSION
  gem.summary = 'Virtual network in seconds.'
  gem.description = 'A simple ruby network emulator'\
                    'with capabilities similar to mininet.'

  gem.license = 'GPL3'

  gem.authors = ['Yasuhito Takamiya']
  gem.email = ['yasuhito@gmail.com']
  gem.homepage = 'http://github.com/trema/phut'

  gem.files = `git ls-files`.split("\n")

  gem.require_paths = ['lib']
  gem.extensions = ['Rakefile']

  gem.extra_rdoc_files = ['README.md']
  gem.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  gem.add_dependency 'gli', '~> 2.11.0'
  gem.add_dependency 'pry', '~> 0.10.0'

  # Docs
  gem.add_development_dependency 'relish', '~> 0.7'
  gem.add_development_dependency 'yard', '~> 0.8.7.4'

  # Development
  gem.add_development_dependency 'byebug', '~> 3.1.2'
  gem.add_development_dependency 'guard', '~> 2.6.1'
  gem.add_development_dependency 'guard-bundler', '~> 2.0.0'
  gem.add_development_dependency 'guard-cucumber', '~> 1.4.1'
  gem.add_development_dependency 'guard-rspec', '~> 4.2.10'
  gem.add_development_dependency 'guard-rubocop', '~> 1.1.0'

  # Test
  gem.add_development_dependency 'aruba', '~> 0.6.0'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'coveralls', '~> 0.7.0'
  gem.add_development_dependency 'cucumber', '~> 1.3.15'
  gem.add_development_dependency 'fuubar', '~> 1.3.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.99'
  gem.add_development_dependency 'rspec-given', '~> 3.5.4'
  gem.add_development_dependency 'rubocop', '~> 0.24.0'
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
