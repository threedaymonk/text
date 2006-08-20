require File.join(File.dirname(__FILE__), 'preamble')

class LevenshteinTest < Test::Unit::TestCase

  include Text::Levenshtein

  TEST_CASES = [
    # Easy ones
    ['test', 'test', 0],
    ['test', 'tent', 1],
    ['gumbo', 'gambol', 2],
    ['kitten', 'sitting', 3],
    # Empty strings
    ['foo', '', 3],
    ['', '', 0],
    ['a', '', 1],
    # UTF-8
    ["f\303\266o", 'foo', 1],
    ["fran\303\247ais", 'francais', 1],
    ["fran\303\247ais", "fran\303\246ais", 1],
    ["\347\247\201\343\201\256\345\220\215\345\211\215\343\201\257"<<
     "\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231",
     "\343\201\274\343\201\217\343\201\256\345\220\215\345\211\215\343\201"<<
     "\257\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231", 
     2], # Japanese
    # Edge cases
    ['a', 'a', 0],
    ['0123456789', 'abcdefghijklmnopqrstuvwxyz', 26]
  ]

  def test_known_distances
    TEST_CASES.each do |a, b, x|
      assert_equal x, distance(a, b)
      assert_equal x, distance(b, a)
    end
  end

end