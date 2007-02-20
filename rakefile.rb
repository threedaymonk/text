require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rcov/rcovtask'
require 'rake/rdoctask'

gemspec = Gem::Specification.new do |s|
  s.name = 'Text'
  s.version = '1.1.2'
  s.summary ='A collection of text algorithms'
  s.files = FileList['{lib,test}/**/*.*', 'README.rdoc', 'rakefile.rb']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.rubyforge_project = 'text'
  s.homepage = 'http://text.rubyforge.org/'
  s.author = 'Paul Battley, Michael Neumann, Tim Fletcher'
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar_gz = true
end

Rake::PackageTask.new(gemspec.name, gemspec.version) do |pkg|
  pkg.need_tar_gz = true
  pkg.package_files.include gemspec.files
end

Rake::TestTask.new do |t|
  t.verbose = false
end

Rcov::RcovTask.new do |t|
  t.rcov_opts = []
end

Rake::RDocTask.new do |t|
  t.main = 'README.rdoc'
  t.rdoc_files.include 'README.rdoc', 'lib/**/*.rb'
end

task :default => :test
