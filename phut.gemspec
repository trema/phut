# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phut/version'

Gem::Specification.new do |gem|
  gem.name = 'phut'
  gem.version = Phut::VERSION
  gem.summary = 'Virtual network in seconds.'
  gem.description = 'A simple network emulator '\
                    'with capabilities similar to mininet.'

  gem.licenses = %w[GPLv2 MIT]

  gem.authors = ['Yasuhito Takamiya']
  gem.email = ['yasuhito@gmail.com']
  gem.homepage = 'http://github.com/trema/phut'

  gem.executables = %w[phut vhost]
  gem.files = `git ls-files`.split("\n")

  gem.extra_rdoc_files = ['README.md']
  gem.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'activesupport', '~> 5.0.2'
  gem.add_dependency 'gli', '~> 2.16.0'
  gem.add_dependency 'pio', '~> 0.30.1'
  gem.add_dependency 'pry', '~> 0.10.3'
end
