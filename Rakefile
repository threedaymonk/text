require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rcov/rcovtask'
require 'rake/rdoctask'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'text/version'

gemspec = Gem::Specification.new do |s|
  s.name              = 'text'
  s.version           = Text::VERSION::STRING
  s.summary           = 'A collection of text algorithms'
  s.description       = 'A collection of text algorithms: Levenshtein, Soundex, Metaphone, Double Metaphone, Figlet, Porter Stemming'
  s.files             = FileList['{lib,test}/**/*', 'README.rdoc', 'Rakefile']
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w[README.rdoc]
  s.rubyforge_project = 'text'
  s.homepage          = 'http://github.com/threedaymonk/text'
  s.authors           = ['Paul Battley', 'Michael Neumann', 'Tim Fletcher']
  s.email             = "pbattley@gmail.com"
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
