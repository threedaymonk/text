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
  class SimonSimilarity
    def initialize
      @word_letter_pairs = {}
    end

    def compare_strings(str1, str2)
      pairs1 = word_letter_pairs(str1)
      pairs2 = word_letter_pairs(str2)

      intersection = 0
      union = pairs1.length + pairs2.length

      pairs1.each do |pair|
        if pairs2.include?(pair)
          intersection += 1
        end
      end

      (2.0 * intersection) / union
    end

  private
    def word_letter_pairs(str)
      @word_letter_pairs[str] ||= Set.new(
        str.upcase.split(/\s+/).map{ |word|
          (0 ... (word.length - 1)).map { |i| str[i, 2] }
        }.flatten
      )
    end

    def self.compare_strings(str1, str2)
      new.compare_strings(str1, str2)
    end
  end
end
