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
  #
  # In Ruby 1.8, +str1+ and +str2+ should be ASCII, UTF-8, or a one-byte-per
  # character encoding such as ISO-8859-*. They will be treated as UTF-8 if
  # $KCODE is set appropriately (i.e. 'u').  Otherwise, the comparison will be
  # performed byte-by-byte. There is no specific support for Shift-JIS or EUC
  # strings.
  #
  # In Ruby 1.9+, the strings will be processed as UTF-8.
  #
  # When using Unicode text, be aware that this algorithm does not perform
  # normalisation.  If there is a possibility of different normalised forms
  # being used, normalisation should be performed beforehand.
  #
  def distance(str1, str2)
    prepare =
      if "ruby".respond_to?(:encoding)
        lambda { |str| str.encode(Encoding::UTF_8).unpack("U*") }
      else
        rule = $KCODE.match(/^U/i) ? "U*" : "C*"
        lambda { |str| str.unpack(rule) }
      end

    s, t = [str1, str2].map(&prepare)
    n = s.length
    m = t.length
    return m if n.zero?
    return n if m.zero?

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
      end
      d[m] = x
    end

    return x
  end

  extend self
end
end
