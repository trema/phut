lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phut/version'

Gem::Specification.new do |gem|
  gem.name = 'phut'
  gem.version = Phut::VERSION
  gem.summary = 'Virtual network in seconds.'
  gem.description = 'A simple network emulator '\
                    'with capabilities similar to mininet.'

  gem.license = 'GPL3'

  gem.authors = ['Yasuhito Takamiya']
  gem.email = ['yasuhito@gmail.com']
  gem.homepage = 'http://github.com/trema/phut'

  gem.executables = %w(phut vhost)
  gem.files = `git ls-files`.split("\n")

  gem.extra_rdoc_files = ['README.md']
  gem.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'activesupport', '~> 4.2', '>= 4.2.5'
  gem.add_dependency 'gli', '~> 2.13.4'
  gem.add_dependency 'pio', '~> 0.30.0'
  gem.add_dependency 'pry', '~> 0.10.3'

  # Docs
  gem.add_development_dependency 'relish'
  gem.add_development_dependency 'yard', '~> 0.8.7.6'

  # Development
  gem.add_development_dependency 'guard', '~> 2.13.0'
  gem.add_development_dependency 'guard-bundler', '~> 2.1.0'
  gem.add_development_dependency 'guard-cucumber', '~> 2.0.0'
  gem.add_development_dependency 'guard-rspec', '~> 4.6.4'
  gem.add_development_dependency 'guard-rubocop', '~> 1.2.0'

  # Test
  gem.add_development_dependency 'aruba', '~> 0.11.2'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'coveralls', '~> 0.8.10'
  gem.add_development_dependency 'cucumber', '~> 2.1.0'
  gem.add_development_dependency 'flay', '~> 2.6.1'
  gem.add_development_dependency 'flog', '~> 4.3.2'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'reek', '~> 3.7.1'
  gem.add_development_dependency 'rspec', '~> 3.4.0'
  gem.add_development_dependency 'rspec-given', '~> 3.7.1'
  gem.add_development_dependency 'rubocop', '~> 0.35.1'
end
