source 'https://rubygems.org'

group :development, :test do
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'cucumber', '~> 1.3.10'
  if RUBY_VERSION >= '1.9.0'
    gem 'guard', '~> 2.2.4'
    gem 'guard-bundler', '~> 2.0.0'
    gem 'guard-rspec', '~> 4.0.4'
    gem 'guard-rubocop', '~> 1.0.0'
  end
  gem 'mime-types' if RUBY_VERSION >= '1.9.0'
  gem 'mime-types', '~> 1.25' if RUBY_VERSION < '1.9.0'
  gem 'rspec', '~> 2.14.1'
  gem 'rubocop', '~> 0.15.0' if RUBY_VERSION >= '1.9.0'
end
