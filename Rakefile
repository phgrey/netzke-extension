require "bundler/gem_tasks"

#Unit::Test stuff
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
end
desc "Run tests"

#Rspec stuff
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

task :default => :spec
