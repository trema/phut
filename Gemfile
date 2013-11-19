source 'https://rubygems.org'

group :development, :test do
  gem 'aruba', '~> 0.5.3'
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'cucumber', '= 1.3.9'
  if RUBY_VERSION >= '1.9.0'
    gem 'guard', '~> 2.2.4'
    gem 'guard-cucumber', '~> 1.4.0'
    gem 'guard-bundler', '~> 2.0.0'
    gem 'guard-rspec', '~> 4.0.4'
    gem 'guard-rubocop', '~> 1.0.0'
  end
  gem 'json', '~> 1.8.1'
  gem 'mime-types', '~> 1.25' if RUBY_VERSION < '1.9.0'
  gem 'mime-types', '~> 2.0' if RUBY_VERSION >= '1.9.0'
  gem 'rspec', '~> 2.14.1'
  gem 'rubocop', '~> 0.15.0' if RUBY_VERSION >= '1.9.0'
end
