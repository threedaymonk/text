# encoding: utf-8
# Original author: Wilker Lúcio <wilkerlucio@gmail.com>

module Text

  # Ruby implementation of the string similarity described by Simon White
  # at: http://www.catalysoft.com/articles/StrikeAMatch.html
  #
  #                        2 * |pairs(s1) INTERSECT pairs(s2)|
  #   similarity(s1, s2) = -----------------------------------
  #                            |pairs(s1)| + |pairs(s2)|
  #
  # e.g.
  #                                             2 * |{FR, NC}|
  #   similarity(FRANCE, FRENCH) = ---------------------------------------
  #                                |{FR,RA,AN,NC,CE}| + |{FR,RE,EN,NC,CH}|
  #
  #                              = (2 * 2) / (5 + 5)
  #
  #                              = 0.4
  #
  #   WhiteSimilarity.new.similarity("FRANCE", "FRENCH")
  #
  class WhiteSimilarity

    def self.similarity(str1, str2)
      new.similarity(str1, str2)
    end

    def initialize
      @word_letter_pairs = {}
    end

    def similarity(str1, str2)
      pairs1 = word_letter_pairs(str1)
      pairs2 = word_letter_pairs(str2)

      union = pairs1.length + pairs2.length

      pairs1.uniq!
      pairs2.uniq!

      intersection = pairs1.inject(0) { |acc, pair|
        pairs2.include?(pair) ? acc + 1 : acc
      }

      (2.0 * intersection) / union
    end

  private

    def word_letter_pairs(str)
      @word_letter_pairs[str] ||= str.upcase.split(/\s+/).map { |word|
        (0 ... (word.length - 1)).map { |i| word[i, 2] }
      }.flatten
    end

  end
end
