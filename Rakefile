#!/usr/bin/env rake
begin
  require "bundler/gem_tasks"
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Dir.glob('tasks/*.rake').each { |r| import r }

ENV["RAILS_ROOT"] ||= 'spec/internal'

desc 'Run CI tests in e.g. Travis environment'
task :travis => ['clean', 'ci']

desc 'Default: run CI'
task :default => [:travis]
