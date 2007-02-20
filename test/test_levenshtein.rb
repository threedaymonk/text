require File.join(File.dirname(__FILE__), 'preamble')

class LevenshteinTest < Test::Unit::TestCase

  include Text::Levenshtein

  TEST_CASES = {
    :easy => [
      ['test', 'test', 0],
      ['test', 'tent', 1],
      ['gumbo', 'gambol', 2],
      ['kitten', 'sitting', 3]
    ],
    :empty => [
      ['foo', '', 3],
      ['', '', 0],
      ['a', '', 1]
    ],
    :utf8 => [
      ["f\303\266o", 'foo', 1],
      ["fran\303\247ais", 'francais', 1],
      ["fran\303\247ais", "fran\303\246ais", 1],
      [
        "\347\247\201\343\201\256\345\220\215\345\211\215\343\201\257"<<
        "\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231",
        "\343\201\274\343\201\217\343\201\256\345\220\215\345\211\215\343\201"<<
        "\257\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231",
        2
      ] # Japanese
    ],
    :iso_8859_1 => [
      ["f\366o", 'foo', 1],
      ["fran\347ais", 'francais', 1],
      ["fran\347ais", "fran\346ais", 1]
    ],
    :edge => [
      ['a', 'a', 0],
      ['0123456789', 'abcdefghijklmnopqrstuvwxyz', 26]
    ]
  }

  def assert_set(name)
    TEST_CASES[name].each do |s, t, x|
      assert_equal x, distance(s, t)
      assert_equal x, distance(t, s)
    end
  end

  def with_kcode(k)
    old_kcode = $KCODE
    $KCODE = k
    yield
    $KCODE = old_kcode
  end

  def test_easy_cases
    assert_set(:easy)
  end

  def test_empty_cases
    assert_set(:empty)
  end

  def test_edge_cases
    assert_set(:edge)
  end

  def test_utf8_cases
    with_kcode('U') do
      assert_set(:utf8)
    end
  end

  def test_iso_8859_1_cases
    with_kcode('NONE') do
      assert_set(:iso_8859_1)
    end
  end

end
