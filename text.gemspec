require File.expand_path('../lib/text/version', __FILE__)

gemspec = Gem::Specification.new do |s|
  s.name              = 'text'
  s.version           = Text::VERSION::STRING
  s.summary           = 'A collection of text algorithms'
  s.description       = 'A collection of text algorithms: Levenshtein, Soundex, Metaphone, Double Metaphone, Porter Stemming'
  s.files             = Dir.glob("{lib,test}/**/*") + %w{README.rdoc Rakefile}
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w[README.rdoc]
  s.rubyforge_project = 'text'
  s.homepage          = 'http://github.com/threedaymonk/text'
  s.authors           = ['Paul Battley', 'Michael Neumann', 'Tim Fletcher']
  s.email             = "pbattley@gmail.com"
end
