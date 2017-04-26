# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pio', github: 'trema/pio', branch: 'develop'

group :test do
  gem 'aruba', require: false
  gem 'cucumber', require: false
  gem 'faker', require: false
  gem 'minitest', require: false
  gem 'rake', require: false
end

group :metrics do
  gem 'codeclimate-test-reporter', require: false
  gem 'coveralls', require: false
  gem 'flay', require: false
  gem 'flog', require: false
  gem 'reek', require: false
  gem 'rubocop', require: false
end

group :doc do
  gem 'yard', require: false
end
