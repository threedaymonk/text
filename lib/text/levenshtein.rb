#
# Levenshtein distance algorithm implementation for Ruby, with UTF-8 support.
#
# The Levenshtein distance is a measure of how similar two strings s and t are,
# calculated as the number of deletions/insertions/substitutions needed to
# transform s into t. The greater the distance, the more the strings differ.
#
# The Levenshtein distance is also sometimes referred to as the
# easier-to-pronounce-and-spell 'edit distance'.
#
# Author: Paul Battley (pbattley@gmail.com)
#

module Text # :nodoc:
module Levenshtein

  # Calculate the Levenshtein distance between two strings +str1+ and +str2+.
  #
  # Optional argument max_distance, makes the algorithm to stop if Levenshtein
  # distance is greater or equal to it. Increase performance avoiding full
  # distance calculations in case you only need to compare strings
  # distances with a reference value.
  #
  # The distance is calculated in terms of Unicode codepoints. Be aware that
  # this algorithm does not perform normalisation: if there is a possibility
  # of different normalised forms being used, normalisation should be performed
  # beforehand.
  #
  def distance(str1, str2, max_distance = -1)
    s, t = [str1, str2].map{ |str| str.encode(Encoding::UTF_8).unpack("U*") }
    n = s.length
    m = t.length
    return m if n.zero?
    return n if m.zero?

    # if the length difference is already greater than the max_distance, then
    # there is nothing else to check
    return max_distance if max_distance >= 0 && (n - m).abs >= max_distance

    d = (0..m).to_a
    x = nil

    n.times do |i|
      e = i + 1
      m.times do |j|
        cost = (s[i] == t[j]) ? 0 : 1
        x = [
          d[j+1] + 1, # insertion
          e + 1,      # deletion
          d[j] + cost # substitution
        ].min

        d[j] = e
        e = x

        # if the diagonal value is already greater than the max_distance
        # then we can safety return as diagonal will never go lower again
        return max_distance if j == i+1 && max_distance >= 0 && d[j] >= max_distance
      end
      d[m] = x
    end

    return x
  end

  extend self
end
end
