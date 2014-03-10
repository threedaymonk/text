$:.unshift File.expand_path("../../lib", __FILE__)
require "text/levenshtein"

class LevenshteinJob
  def initialize
    @words = File.read("/usr/share/dict/words").split(/\n/)
  end

  def warm_up
    run @words.take(100), nil
  end

  def run_with_no_max
    run @words, nil
  end

  def run_with_max(max)
    run @words, max
  end

  def run(words, max)
    words.each_cons(2) do |a, b|
      Text::Levenshtein.distance(a, b, max)
    end
  end
end
