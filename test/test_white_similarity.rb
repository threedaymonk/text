require File.join(File.dirname(__FILE__), 'preamble')
require "text/white_similarity"

class WhiteSimilarityTest < Test::Unit::TestCase

  def test_similarity
    word = "Healed"

    assert_in_delta 0.8,  Text::WhiteSimilarity.compare_strings(word, "Sealed"),  0.01
    assert_in_delta 0.55, Text::WhiteSimilarity.compare_strings(word, "Healthy"), 0.01
    assert_in_delta 0.44, Text::WhiteSimilarity.compare_strings(word, "Heard"),   0.01
    assert_in_delta 0.40, Text::WhiteSimilarity.compare_strings(word, "Herded"),  0.01
    assert_in_delta 0.25, Text::WhiteSimilarity.compare_strings(word, "Help"),    0.01
    assert_in_delta 0.0,  Text::WhiteSimilarity.compare_strings(word, "Sold"),    0.01
  end

  def test_similarity_with_caching
    word = "Healed"

    similarity = Text::WhiteSimilarity.new

    assert_in_delta 0.8,  similarity.compare_strings(word, "Sealed"),  0.01
    assert_in_delta 0.55, similarity.compare_strings(word, "Healthy"), 0.01
    assert_in_delta 0.44, similarity.compare_strings(word, "Heard"),   0.01
    assert_in_delta 0.40, similarity.compare_strings(word, "Herded"),  0.01
    assert_in_delta 0.25, similarity.compare_strings(word, "Help"),    0.01
    assert_in_delta 0.0,  similarity.compare_strings(word, "Sold"),    0.01
  end
end
