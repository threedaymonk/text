require File.join(File.dirname(__FILE__), 'preamble')
require "text/porter_stemming"

class PorterStemmingTest < Test::Unit::TestCase

  def slurp(*path)
    File.read(File.rel(*path)).split(/\n/)
  end

  def test_cases
    cases = slurp('data', 'porter_stemming_input.txt').zip(slurp('data', 'porter_stemming_output.txt'))
    cases.each do |word, expected_output|
      assert_equal expected_output, Text::PorterStemming.stem(word)
    end
  end

end
