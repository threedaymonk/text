require File.join(File.dirname(__FILE__), 'preamble')
require "text/simon_similarity"

class SimonSimilarityTest < Test::Unit::TestCase
  include Text::SimonSimilarity

  def test_similarity
    word = "Healed"

    assert_in_delta 0.8,  compare_strings(word, "Sealed"),  0.01
    assert_in_delta 0.55, compare_strings(word, "Healthy"), 0.01
    assert_in_delta 0.44, compare_strings(word, "Heard"),   0.01
    assert_in_delta 0.40, compare_strings(word, "Herded"),  0.01
    assert_in_delta 0.25, compare_strings(word, "Help"),    0.01
    assert_in_delta 0.0,  compare_strings(word, "Sold"),    0.01
  end

  def test_add_to_index
    index = create_index
    index.add "Test"
    index.add "Text"

    assert index.index["Te"].include?("Test"), "Index 'Te' not includes Test"
    assert index.index["es"].include?("Test"), "Index 'es' not includes Test"
    assert index.index["st"].include?("Test"), "Index 'st' not includes Test"

    assert index.index["Te"].include?("Text"), "Index 'Te' not includes Text"
    assert index.index["ex"].include?("Text"), "Index 'ex' not includes Text"
    assert index.index["xt"].include?("Text"), "Index 'xt' not includes Text"

    assert !index.index["es"].include?("Text"), "Index 'es' includes Text"
    assert !index.index["ex"].include?("Test"), "Index 'ex' includes Test"
  end

  def test_add_to_index_dont_repeat
    index = create_index

    index.add "tete"

    assert_equal 1, index.index["te"].length
  end

  def test_indexed_search
    index = create_index
    index.add "Sealed"
    index.add "Healthy"
    index.add "Heard"
    index.add "Herded"
    index.add "Help"
    index.add "Sold"

    results = index.search("Healed")

    assert_equal ["Sealed", 0.8], results[0]
  end
end
