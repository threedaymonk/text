require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rcov/rcovtask'

gemspec = Gem::Specification.new do |s|
  s.name = 'Text'
  s.version = '1.0.0'
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

Rake::PackageTask.new('text', '1.0.0') do |p|
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

task :default => :test

desc 'Make figlets!'
task :figlet do
  $:.unshift File.join(File.dirname(__FILE__), 'lib')
  require 'text/figlet'
  figlet = Text::Figlet::Typesetter.new(Text::Figlet::Font.new('test/data/big.flf'))
  puts figlet[ENV['TEXT'] || 'Hello World']
end