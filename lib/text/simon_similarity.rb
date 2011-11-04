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
    def create_index
      SimonIndex.new
    end

    def compare_strings(str1, str2)
      pairs1 = word_letter_pairs(str1)
      pairs2 = word_letter_pairs(str2)

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
      str = str.upcase
      num_pairs = str.length - 1
      pairs = []

      0.upto(num_pairs - 1) do |n|
        pairs << str[n, 2]
      end

      pairs
    end

    extend self
  end

  class SimonIndex
    include Text::SimonSimilarity

    attr_reader :index

    def initialize
      @index = {}
    end

    def add(word)
      pairs = word_letter_pairs(word)

      for pair in pairs
        @index[pair] = [] unless @index[pair]
        @index[pair] << word unless @index[pair].include?(word)
      end
    end

    def search(query)
      pairs = word_letter_pairs(query)
      matches = {}

      for pair in pairs
        words = @index[pair] || []

        for word in words
          unless matches[word]
            wpairs = word_letter_pairs(word)
            matches[word] = [0, pairs.length + wpairs.length, wpairs]
          end

          matches[word][0] += 1
          matches[word][2].each_with_index do |wpair, j|
            if wpair == pair
              matches[word][2].delete_at(j)
              break
            end
          end
        end
      end

      matches.map do |key, value|
        [key, (2.0 * value[0]) / value[1]]
      end.sort do |a, b| # poor way to sort, just to work on definition, it deserves a better sort algorithm to run while searching in future
        (b[1] <=> a[1])
      end
    end
  end
end
