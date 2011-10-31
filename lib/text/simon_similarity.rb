# encoding: utf-8
#
# Ruby implementation of the string similarity described by Simon White
# at: http://www.catalysoft.com/articles/StrikeAMatch.html
#
# Based on Java implementation of the article
#
# Author: Wilker Lúcio <wilkerlucio@gmail.com>
#

module Text
  module SimonSimilarity
    def compare_strings(str1, str2)
      pairs1 = word_letter_pairs(str1.upcase)
      pairs2 = word_letter_pairs(str2.upcase)

      intersection = 0
      union = pairs1.length + pairs2.length

      pairs1.each do |pair1|
        pairs2.each_with_index do |pair2, j|
          if pair1 == pair2
            intersection += 1
            pairs2.delete_at(j)
            break
          end
        end
      end

      (2.0 * intersection) / union
    end

    private

    def word_letter_pairs(str)
      pairs = []
      words = str.split(/\s+/)

      words.each do |word|
        pairs_in_word = letter_pairs(word)
        pairs.concat(pairs_in_word)
      end

      pairs
    end

    def letter_pairs(str)
      num_pairs = str.length - 1
      pairs = []

      0.upto(num_pairs - 1) do |n|
        pairs << str[n, 2]
      end

      pairs
    end

    extend self
  end
end
