# coding: UTF-8

require_relative "./test_helper"
require "text/levenshtein"

class LevenshteinTest < Test::Unit::TestCase
  include Text::Levenshtein

  def iso_8859_1(s)
    s.force_encoding(Encoding::ISO_8859_1)
  end

  def test_should_calculate_lengths_for_basic_examples
    assert_equal 0, distance("test", "test")
    assert_equal 1, distance("test", "tent")
    assert_equal 2, distance("gumbo", "gambol")
    assert_equal 3, distance("kitten", "sitting")
  end

  def test_should_give_full_distances_for_empty_strings
    assert_equal 3, distance("foo", "")
    assert_equal 0, distance("", "")
    assert_equal 1, distance("a", "")
  end

  def test_should_treat_utf_8_codepoints_as_one_element
    assert_equal 1, distance("föo", "foo")
    assert_equal 1, distance("français", "francais")
    assert_equal 1, distance("français", "franæais")
    assert_equal 2, distance("私の名前はポールです", "ぼくの名前はポールです")
  end

  def test_should_process_single_byte_encodings
    assert_equal 1, distance(iso_8859_1("f\xF6o"), iso_8859_1("foo"))
    assert_equal 1, distance(iso_8859_1("fran\xE7ais"), iso_8859_1("francais"))
    assert_equal 1, distance(iso_8859_1("fran\xE7ais"), iso_8859_1("fran\xE6ais"))
  end

  def test_should_process_edge_cases_as_expected
    assert_equal 0, distance("a", "a")
    assert_equal 26, distance("0123456789", "abcdefghijklmnopqrstuvwxyz")
  end

  def test_should_return_calculated_distance_when_less_than_maximum
    assert_equal 0, distance("test", "test", 1)
    assert_equal 1, distance("test", "tent", 2)
    assert_equal 2, distance("gumbo", "gambol", 3)
    assert_equal 3, distance("kitten", "sitting", 4)
  end

  def test_should_return_calculated_distance_when_same_as_maximum
    assert_equal 0, distance("test", "test", 0)
    assert_equal 1, distance("test", "tent", 1)
    assert_equal 2, distance("gumbo", "gambol", 2)
    assert_equal 3, distance("kitten", "sitting", 3)
  end

  def test_should_return_specified_maximum_if_distance_is_more
    assert_equal 1, distance("gumbo", "gambol", 1)
    assert_equal 2, distance("kitten", "sitting", 2)
    assert_equal 1, distance("test", "tasf", 1)
  end
end
