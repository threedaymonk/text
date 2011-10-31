require File.join(File.dirname(__FILE__), 'preamble')
require "text/simon_similarity"

class SimonSimilarityTest < Test::Unit::TestCase
  def test_similarity
    word = "Healed"

    assert_in_delta 0.8,  Text::SimonSimilarity.compare_strings(word, "Sealed"),  0.01
    assert_in_delta 0.55, Text::SimonSimilarity.compare_strings(word, "Healthy"), 0.01
    assert_in_delta 0.44, Text::SimonSimilarity.compare_strings(word, "Heard"),   0.01
    assert_in_delta 0.40, Text::SimonSimilarity.compare_strings(word, "Herded"),  0.01
    assert_in_delta 0.25, Text::SimonSimilarity.compare_strings(word, "Help"),    0.01
    assert_in_delta 0.0,  Text::SimonSimilarity.compare_strings(word, "Sold"),    0.01
  end
end
