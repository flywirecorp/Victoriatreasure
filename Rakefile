require "rspec/core/rake_task"
require 'rake'
require 'semver'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Semver increase Patch version'
task :spatch do
  v = SemVer.find
  v.patch += 1
  puts v.to_s
  v.save
end

desc 'Semver increase Minor version'
task :sminor do
  v = SemVer.find
  v.minor += 1
  v.patch = 0
  puts v.to_s
  v.save
end

desc 'Semver increase Major version'
task :smajor do
  v = SemVer.find
  v.major += 1
  v.minor = 0
  v.patch = 0
  puts v.to_s
  v.save
end

desc 'Create a new tag with current version'
task :stag do
  v = SemVer.find
  sh "git tag -a #{v.to_s} -m 'Tagging #{v.to_s}'"
end
