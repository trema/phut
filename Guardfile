# encoding: utf-8

guard :rspec do
  watch(%r{^spec/phuture/.+_spec\.rb$})
  watch(%r{^lib/phuture/(.+)\.rb$})     { |m| "spec/phuture/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }
end

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if your Gemfile contains the `gemspec' command.
  # watch(/^.+\.gemspec/)
end

guard :rubocop, all_on_start: false do
  watch('bin/phut')
  watch(/.+\.rb$/)
  watch(/{(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
end

guard 'cucumber', cli: '--tags ~@sudo' do
  watch('bin/phut') { 'features' }
  watch(/^features\/.+\.feature$/)
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
  end
end
