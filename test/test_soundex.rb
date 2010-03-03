require File.join(File.dirname(__FILE__), 'preamble')
require "text/soundex"
require 'yaml'

class SoundexTest < Test::Unit::TestCase

  def test_cases
    YAML.load(%{

      Euler: E460
      Ellery: E460
      Gauss: G200
      Ghosh: G200
      Hilbert: H416
      Heilbronn: H416
      Knuth: K530
      Kant: K530
      Lloyd: L300
      Ladd: L300
      Lukasiewicz: L222
      Lissajous: L222

    }).each do |input, expected_output|
      assert_equal expected_output, Text::Soundex.soundex(input)
    end
  end

end
