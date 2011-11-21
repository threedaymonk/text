require File.join(File.dirname(__FILE__), 'preamble')
require "text/white_similarity"

class WhiteSimilarityTest < Test::Unit::TestCase

  def test_similarity
    word = "Healed"

    assert_in_delta 0.8,  Text::WhiteSimilarity.similarity(word, "Sealed"),  0.01
    assert_in_delta 0.55, Text::WhiteSimilarity.similarity(word, "Healthy"), 0.01
    assert_in_delta 0.44, Text::WhiteSimilarity.similarity(word, "Heard"),   0.01
    assert_in_delta 0.40, Text::WhiteSimilarity.similarity(word, "Herded"),  0.01
    assert_in_delta 0.25, Text::WhiteSimilarity.similarity(word, "Help"),    0.01
    assert_in_delta 0.0,  Text::WhiteSimilarity.similarity(word, "Sold"),    0.01
  end

  def test_similarity_with_caching
    word = "Healed"

    white = Text::WhiteSimilarity.new

    assert_in_delta 0.8,  white.similarity(word, "Sealed"),  0.01
    assert_in_delta 0.55, white.similarity(word, "Healthy"), 0.01
    assert_in_delta 0.44, white.similarity(word, "Heard"),   0.01
    assert_in_delta 0.40, white.similarity(word, "Herded"),  0.01
    assert_in_delta 0.25, white.similarity(word, "Help"),    0.01
    assert_in_delta 0.0,  white.similarity(word, "Sold"),    0.01
  end
end
