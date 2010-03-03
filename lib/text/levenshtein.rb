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

require "text/util"

module Text # :nodoc:
module Levenshtein

  # Calculate the Levenshtein distance between two strings +str1+ and +str2+.
  # +str1+ and +str2+ should be ASCII, UTF-8, or a one-byte-per character encoding such
  # as ISO-8859-*.
  #
  # The strings will be treated as UTF-8 if $KCODE is set appropriately (i.e. 'u').
  # Otherwise, the comparison will be performed byte-by-byte. There is no specific support
  # for Shift-JIS or EUC strings.
  #
  # When using Unicode text, be aware that this algorithm does not perform normalisation.
  # If there is a possibility of different normalised forms being used, normalisation
  # should be performed beforehand.
  #
  def distance(str1, str2)
    encoding = defined?(Encoding) ? str1.encoding.to_s : $KCODE

    if Text.encoding_of(str1) =~ /^U/i
      unpack_rule = 'U*'
    else
      unpack_rule = 'C*'
    end

    s = str1.unpack(unpack_rule)
    t = str2.unpack(unpack_rule)
    n = s.length
    m = t.length
    return m if (0 == n)
    return n if (0 == m)

    d = (0..m).to_a
    x = nil

    (0...n).each do |i|
      e = i+1
      (0...m).each do |j|
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

    return x
  end

  extend self
end
end
