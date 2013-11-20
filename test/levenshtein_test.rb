require "test_helper"
require "text/levenshtein"

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
    ],
    :max_distance => [
        #max_distance = 1
        ['gumbo', 'gumbo1', 1],
        ['gumbo', 'gambo1', 1]
    ],
    :max_distance_utf8 => [
      #max_distance = 1
      [
        "\347\247\201\343\201\256\345\220\215\345\211\215\343\201\257"<<
        "\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231",
        "\343\201\274\343\201\217\343\201\256\345\220\215\345\211\215\343\201"<<
        "\257\343\203\235\343\203\274\343\203\253\343\201\247\343\201\231",
        1
      ], # Japanese
      ["fran\303\247ais", 'francais2', 1]
    ],
    :max_distance_iso_8859_1=> [
      #max_distance = 1
      ["f\366o", 'foo', 1],
      ["fran\347ais", 'francais2', 1]
    ]
  }

  MAX_DISTANCE = 1

  def assert_set(name)
    TEST_CASES[name].each do |s, t, x|
      if defined?(Encoding) && Encoding.default_internal # Change the encoding if in 1.9
        t.force_encoding(Encoding.default_internal)
        s.force_encoding(Encoding.default_internal)
      end

      assert_equal x, distance(s, t)
      assert_equal x, distance(t, s)
    end
  end

  def assert_set_max_distance(name)
    TEST_CASES[name].each do |s, t, x|
      if defined?(Encoding) && Encoding.default_internal # Change the encoding if in 1.9
        t.force_encoding(Encoding.default_internal)
        s.force_encoding(Encoding.default_internal)
      end

      assert_equal x, distance(s, t, MAX_DISTANCE)
      assert_equal x, distance(t, s, MAX_DISTANCE)
    end
  end

  def with_encoding(kcode, encoding)
    if "ruby".respond_to?(:encoding)
      old_encoding = Encoding.default_internal
      Encoding.default_internal = encoding
      yield
      Encoding.default_internal = old_encoding
    else # 1.8 backwards compat
      old_kcode = $KCODE
      $KCODE = kcode
      yield
      $KCODE = old_kcode
    end
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
    with_encoding('U', 'UTF-8') do
      assert_set(:utf8)
    end
  end

  def test_iso_8859_1_cases
    with_encoding('NONE', 'ISO-8859-1') do
      assert_set(:iso_8859_1)
    end
  end

  def test_max_distance_cases
    assert_set_max_distance(:max_distance)
  end

  def test_max_distance_utf8_cases
    with_encoding('U', 'UTF-8') do
      assert_set_max_distance(:max_distance_utf8)
    end
  end

  def test_max_distance_iso_8859_1_cases
    with_encoding('NONE', 'ISO-8859-1') do
      assert_set_max_distance(:max_distance_iso_8859_1)
    end
  end

end
