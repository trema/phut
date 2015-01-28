lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phut/version'

Gem::Specification.new do |gem|
  gem.name = 'phut'
  gem.version = Phut::VERSION
  gem.summary = 'Virtual network in seconds.'
  gem.description = 'A simple ruby network emulator '\
                    'with capabilities similar to mininet.'

  gem.license = 'GPL3'

  gem.authors = ['Yasuhito Takamiya']
  gem.email = ['yasuhito@gmail.com']
  gem.homepage = 'http://github.com/trema/phut'

  gem.files = `git ls-files`.split("\n")

  gem.extensions = ['Rakefile']

  gem.extra_rdoc_files = ['README.md']
  gem.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  gem.add_dependency 'gli', '~> 2.12.2'
  gem.add_dependency 'pio', '~> 0.11.1'
  gem.add_dependency 'pry', '~> 0.10.1'

  # Docs
  gem.add_development_dependency 'relish'
  gem.add_development_dependency 'yard', '~> 0.8.7.6'

  # Development
  gem.add_development_dependency 'byebug', '~> 3.5.1'
  gem.add_development_dependency 'guard', '~> 2.11.1'
  gem.add_development_dependency 'guard-bundler', '~> 2.1.0'
  gem.add_development_dependency 'guard-cucumber', '~> 1.5.3'
  gem.add_development_dependency 'guard-rspec', '~> 4.5.0'
  gem.add_development_dependency 'guard-rubocop', '~> 1.2.0'

  # Test
  gem.add_development_dependency 'aruba', '~> 0.6.2'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'coveralls', '~> 0.7.2'
  gem.add_development_dependency 'cucumber', '~> 1.3.18'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.1.0'
  gem.add_development_dependency 'rspec-given', '~> 3.6.0'
  gem.add_development_dependency 'rubocop', '~> 0.28.0'
end
