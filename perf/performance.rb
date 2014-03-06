$:.unshift File.expand_path("../../lib", __FILE__)
require "text/levenshtein"

class LevenshteinJob
  def initialize
    @words = File.read("/usr/share/dict/words").split(/\n/)
  end

  def run(max = nil)
    if max
      words = @words.take(max)
    else
      words = @words
    end

    words.each_cons(2) do |a, b|
      Text::Levenshtein.distance(a, b)
    end
  end
end
