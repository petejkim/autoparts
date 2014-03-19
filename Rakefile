# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'rubygems'
require 'bundler'

Bundler.setup

lib = File.expand_path('../lib', __FILE__)
vendor = File.expand_path('../vendor', __FILE__)
[lib, vendor].each do |d|
  $LOAD_PATH.unshift(d) unless $LOAD_PATH.include?(d)
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
