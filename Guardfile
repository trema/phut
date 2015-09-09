guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/phut/.+_spec\.rb$})
  watch(%r{^lib/phut/(.+)\.rb$}) { |m| "spec/phut/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rubocop, all_on_start: false do
  watch('Gemfile')
  watch('Guardfile')
  watch('Rakefile')
  watch('bin/phut')
  watch(/.+\.rake$/)
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'cucumber', cli: '--tags ~@sudo --tags ~@shell' do
  watch('bin/phut') { 'features' }
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
  end
end
