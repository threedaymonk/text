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
  # Optional argument max_distance, reduces iterations and makes the algorithm to
  # stop if Levenshtein distance is greater or equal to it. Increase performance
  # avoiding full distance calculations in case you only need to compare strings
  # distances with a reference value. Usually improves performance more than 100%.
  #
  # The distance is calculated in terms of Unicode codepoints. Be aware that
  # this algorithm does not perform normalisation: if there is a possibility
  # of different normalised forms being used, normalisation should be performed
  # beforehand.
  #
  def distance(str1, str2, max_distance = nil)
    if str1.length > str2.length
      s, t = [str2, str1].map{ |str| str.encode(Encoding::UTF_8).unpack("U*") }
    else
      s, t = [str1, str2].map{ |str| str.encode(Encoding::UTF_8).unpack("U*") }
    end
    n = s.length
    m = t.length
    big_int = n*m
    return m if n.zero?
    return n if m.zero?
    return 0 if s == t

    # if the length difference is already greater than the max_distance, then
    # there is nothing else to check
    if max_distance && (n - m).abs >= max_distance
      return max_distance
    end

    # the values necessary for our threshold are written; the ones after
    # must be filled with large integers since the tailing member of the threshold
    # window in the bottom array will run min across them
    d = Array.new(m+1) { |i| (!max_distance || i < [m, max_distance+1].min) ? i : big_int }
    x = nil
    e = nil

    n.times do |i|
      # since we're reusing arrays, we need to be sure to wipe the value left of the
      # starting index; we don't have to worry about the value above the ending index
      # as the arrays were initially filled with large integers and we progress to the right
      e = !e || !max_distance ? i + 1 : big_int

      diag_index = (t.length - s.length) + i
      if max_distance
        # If max_distance was specified, we can reduce second loop. So we set up our threshold window.
        # See:
        # Gusfield, Dan (1997). Algorithms on strings, trees, and sequences: computer science and computational biology.
        # Cambridge, UK: Cambridge University Press. ISBN 0-521-58519-8.
        # pp. 263–264.
        min = [0, i - max_distance - 1].max
        max = [m-1, i + max_distance].min
      else
        min = 0
        max = m-1
      end

      for j in min..max
        # if the diagonal value is already greater than the max_distance
        # then we can safety return. Diagonal will never go lower again.
        # See: http://www.levenshtein.net/
        if max_distance && j == diag_index && d[j] >= max_distance
          return max_distance
        end

        cost = (s[i] == t[j]) ? 0 : 1
        x = [
          d[j+1] + 1, # insertion
          e + 1,      # deletion
          d[j] + cost # substitution
        ].min

        d[j] = e
        e = x
      end
      d[m] = x
    end

    max_distance && x > max_distance ? max_distance : x
  end

  extend self
end
end
