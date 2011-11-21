# encoding: utf-8
#
# Ruby implementation of the string similarity described by Simon White
# at: http://www.catalysoft.com/articles/StrikeAMatch.html
#
# Based on Java implementation of the article
#
# Author: Wilker Lúcio <wilkerlucio@gmail.com>
#

require "set"

module Text
  module SimonSimilarity
    def compare_strings(str1, str2)
      pairs1 = word_letter_pairs(str1.upcase)
      pairs2 = word_letter_pairs(str2.upcase)

      lookup = Set.new(pairs2)

      intersection = 0
      union = pairs1.length + pairs2.length

      pairs1.each do |pair|
        if lookup.include?(pair)
          lookup.delete pair
          intersection += 1
        end
      end

      (2.0 * intersection) / union
    end

  private
    def word_letter_pairs(str)
      str.split(/\s+/).map{ |word| letter_pairs(word) }.flatten(1)
    end

    def letter_pairs(str)
      (0 ... (str.length - 1)).map { |i| str[i, 2] }
    end

    extend self
  end
end
