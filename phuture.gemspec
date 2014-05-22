lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phuture/version'

Gem::Specification.new do | gem |
  gem.name = 'phuture'
  gem.version = Phuture::VERSION
  gem.summary = 'Virtual network in seconds.'
  gem.description = 'A simple ruby network emulator'\
                    'with capabilities similar to mininet.'

  gem.license = 'GPL3'

  gem.authors = ['Yasuhito Takamiya']
  gem.email = ['yasuhito@gmail.com']
  gem.homepage = 'http://github.com/trema/phuture'

  gem.files = `git ls-files`.split("\n")

  gem.require_paths = ['lib']
  gem.extensions = ['Rakefile']

  gem.extra_rdoc_files = ['README.md']
  gem.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  gem.add_dependency 'gli', '~> 2.10.0'
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
