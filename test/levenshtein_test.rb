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

  def test_should_return_specified_maximum_if_distance_is_more
    assert_equal 1, distance("gumbo", "gambol", 1)
    assert_equal 2, distance("kitten", "sitting", 2)
    assert_equal 1, distance("test", "tasf", 1)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start
    assert_equal 1, distance("1234", "01234")
    assert_equal 0, distance("1234", "01234", 0)
    assert_equal 1, distance("1234", "01234", 1)
    assert_equal 1, distance("1234", "01234", 2)
    assert_equal 1, distance("1234", "01234", 3)
    assert_equal 1, distance("1234", "01234", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_end
    assert_equal 2, distance("1234", "123400") 
    assert_equal 0, distance("1234", "123400", 0)
    assert_equal 1, distance("1234", "123400", 1)
    assert_equal 2, distance("1234", "123400", 2)
    assert_equal 2, distance("1234", "123400", 3)
    assert_equal 2, distance("1234", "123400", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_in_the_middle
    assert_equal 1, distance("1234", "12034")
    assert_equal 0, distance("1234", "12034", 0)
    assert_equal 1, distance("1234", "12034", 1)
    assert_equal 1, distance("1234", "12034", 2)
    assert_equal 1, distance("1234", "12034", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start_and_in_the_middle
    assert_equal 2, distance("1234", "012034")
    assert_equal 0, distance("1234", "012034", 0)
    assert_equal 1, distance("1234", "012034", 1)
    assert_equal 2, distance("1234", "012034", 2)
    assert_equal 2, distance("1234", "012034", 3)
    assert_equal 2, distance("1234", "012034", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_end_and_in_the_middle
    assert_equal 2, distance("1234", "120340")
    assert_equal 0, distance("1234", "120340", 0)
    assert_equal 1, distance("1234", "120340", 1)
    assert_equal 2, distance("1234", "120340", 2)
    assert_equal 2, distance("1234", "120340", 3)
    assert_equal 2, distance("1234", "120340", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start_at_end_and_in_the_middle
    assert_equal 3, distance("1234", "0120340")
    assert_equal 0, distance("1234", "0120340", 0)
    assert_equal 3, distance("1234", "0120340", 3)
    assert_equal 3, distance("1234", "0120340", 4)
    assert_equal 3, distance("1234", "0120340", 6)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start_and_char_changes
    assert_equal 3, distance("1234", "001233")
    assert_equal 0, distance("1234", "001233", 0)
    assert_equal 2, distance("1234", "001233", 2)
    assert_equal 3, distance("1234", "001233", 3)
    assert_equal 3, distance("1234", "001233", 4)
    assert_equal 3, distance("1234", "001233", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_deletions_at_end
    assert_equal 1, distance("1234", "123")
    assert_equal 0, distance("1234", "123", 0)
    assert_equal 1, distance("1234", "123", 1)
    assert_equal 1, distance("1234", "123", 2)
    assert_equal 1, distance("1234", "123", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_deletions_at_start
    assert_equal 1, distance("1234", "234")
    assert_equal 0, distance("1234", "234", 0)
    assert_equal 1, distance("1234", "234", 1)
    assert_equal 1, distance("1234", "234", 2)
    assert_equal 1, distance("1234", "234", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_deletions_at_start_and_in_the_middle
    assert_equal 2, distance("1234", "24")
    assert_equal 0, distance("1234", "24", 0)
    assert_equal 1, distance("1234", "24", 1)
    assert_equal 2, distance("1234", "24", 2)
    assert_equal 2, distance("1234", "24", 3)
    assert_equal 2, distance("1234", "24", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_deletions_at_end_and_in_the_middle
    assert_equal 2, distance("1234", "13")
    assert_equal 0, distance("1234", "13", 0)
    assert_equal 1, distance("1234", "13", 1)
    assert_equal 2, distance("1234", "13", 2)
    assert_equal 2, distance("1234", "13", 3)
    assert_equal 2, distance("1234", "13", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_deletions_at_start_at_end_and_in_the_middle
    assert_equal 3, distance("12345", "24")
    assert_equal 0, distance("12345", "24", 0)
    assert_equal 2, distance("12345", "24", 2)
    assert_equal 3, distance("12345", "24", 3)
    assert_equal 3, distance("12345", "24", 4)
    assert_equal 3, distance("12345", "24", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start_and_deletions_in_the_middle
    assert_equal 2, distance("1234", "0124")
    assert_equal 0, distance("1234", "0124", 0)
    assert_equal 1, distance("1234", "0124", 1)
    assert_equal 2, distance("1234", "0124", 2)
    assert_equal 2, distance("1234", "0124", 3)
    assert_equal 2, distance("1234", "0124", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_start_and_deletions_at_end
    assert_equal 2, distance("1234", "0123")
    assert_equal 0, distance("1234", "0123", 0)
    assert_equal 1, distance("1234", "0123", 1)
    assert_equal 2, distance("1234", "0123", 2)
    assert_equal 2, distance("1234", "0123", 3)
    assert_equal 2, distance("1234", "0123", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_in_the_middle_and_deletions_at_end
    assert_equal 2, distance("1234", "1293")
    assert_equal 0, distance("1234", "1293", 0)
    assert_equal 1, distance("1234", "1293", 1)
    assert_equal 2, distance("1234", "1293", 2)
    assert_equal 2, distance("1234", "1293", 3)
    assert_equal 2, distance("1234", "1293", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_in_the_middle_and_deletions_at_start
    assert_equal 2, distance("1234", "2934")
    assert_equal 0, distance("1234", "2934", 0)
    assert_equal 1, distance("1234", "2934", 1)
    assert_equal 2, distance("1234", "2934", 2)
    assert_equal 2, distance("1234", "2934", 3)
    assert_equal 2, distance("1234", "2934", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_end_and_deletions_at_start
    assert_equal 2, distance("1234", "2345")
    assert_equal 0, distance("1234", "2345", 0)
    assert_equal 1, distance("1234", "2345", 1)
    assert_equal 2, distance("1234", "2345", 2)
    assert_equal 2, distance("1234", "2345", 3)
    assert_equal 2, distance("1234", "2345", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_at_end_and_deletions_in_the_middle
    assert_equal 2, distance("1234", "1245")
    assert_equal 0, distance("1234", "1245", 0)
    assert_equal 1, distance("1234", "1245", 1)
    assert_equal 2, distance("1234", "1245", 2)
    assert_equal 2, distance("1234", "1245", 3)
    assert_equal 2, distance("1234", "1245", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_in_the_middle_and_deletions_in_the_middle
    assert_equal 2, distance("12345", "12035")
    assert_equal 0, distance("12345", "12035", 0)
    assert_equal 1, distance("12345", "12035", 1)
    assert_equal 2, distance("12345", "12035", 2)
    assert_equal 2, distance("12345", "12035", 3)
    assert_equal 2, distance("12345", "12035", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_additions_deletions_and_char_changes
    assert_equal 3, distance("1234", "0193")
    assert_equal 0, distance("1234", "0193", 0)
    assert_equal 1, distance("1234", "0193", 1)
    assert_equal 2, distance("1234", "0193", 2)
    assert_equal 3, distance("1234", "0193", 3)
    assert_equal 3, distance("1234", "0193", 4)
    assert_equal 3, distance("1234", "0193", 5)

    assert_equal 3, distance("1234", "2395")
    assert_equal 0, distance("1234", "2395", 0)
    assert_equal 1, distance("1234", "2395", 1)
    assert_equal 2, distance("1234", "2395", 2)
    assert_equal 3, distance("1234", "2395", 3)
    assert_equal 3, distance("1234", "2395", 4)
    assert_equal 3, distance("1234", "2395", 5)
  end

  def test_should_return_maximum_distance_for_strings_with_only_one_char
    assert_equal 1, distance("t", "a")
    assert_equal 0, distance("t", "a", 0)
    assert_equal 1, distance("t", "a", 1)
    assert_equal 1, distance("t", "a", 2)
    assert_equal 1, distance("t", "a", 10)

    assert_equal 0, distance("t", "t")
    assert_equal 0, distance("t", "t", 1)
    assert_equal 0, distance("t", "t", 4) 

    assert_equal 1, distance("te", "t")
    assert_equal 0, distance("te", "t", 0)
    assert_equal 1, distance("te", "t", 1)
    assert_equal 1, distance("te", "t", 2)
    assert_equal 1, distance("te", "t", 4) 
  end

end
