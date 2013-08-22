require 'rubygems'
require 'bundler'

Bundler.setup

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
