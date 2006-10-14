require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rcov/rcovtask'
require 'rake/rdoctask'

gemspec = Gem::Specification.new do |s|
  s.name = 'Text'
  s.version = '1.1.0'
  s.summary ='A collection of text algorithms'
  s.files = FileList['{lib,test}/**/*.*', '*.txt', 'rakefile.rb']
  s.require_path = 'lib'
  s.autorequire = 'text'
  s.has_rdoc = false
  s.rubyforge_project = 'text'
  s.homepage = 'http://text.rubyforge.org/'
  s.author = 'Paul Battley, Michael Neumann, Tim Fletcher'
end

Rake::GemPackageTask.new(gemspec) { |t| t.package_dir = 'gems' }

Rake::PackageTask.new('Text', '1.1.0') do |p|
  p.need_tar_gz = true
  p.package_files.include('lib/**/*.rb')
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end

Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.output_dir = 'coverage'
  t.rcov_opts = []
end

Rake::RDocTask.new do |t|
  t.main = "README.rdoc"
  t.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

task :default => :test
