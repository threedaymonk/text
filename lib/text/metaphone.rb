#
# An implementation of the Metaphone phonetic coding system in Ruby.
#
# Metaphone encodes names into a phonetic form such that similar-sounding names
# have the same or similar Metaphone encodings.
#
# As there are multiple implementations of Metaphone, each with their own bugs,
# I have based this on my reading of the specification.  This implementation
# has been only lightly tested so far; please report any bugs found to the
# email address given above.
#
# I have also compared this implementation with that found in PHP's standard
# library.  The present implementation follows the algorithm description,
# whilst PHP's implementation mimics the behaviour of LP's original BASIC
# implementation, which appears to contain bugs (specifically with the handling
# of CC and MB).  The changes required for 100% compatibility are noted in the
# code, marked with [PHP].  It would be useful to compare the behaviour of
# other implementations as well.
#
# The original system described by Lawrence Philips in Computer Language Vol. 7
# No. 12, December 1990, pp 39-43:
#
# Author: Paul Battley (pbattley@gmail.com)
#
module Text
module Metaphone

  # Metaphone rules.  These are simply applied in order.
  #
  RULES = [ 
    # Regexp, replacement
    [ /([bcdfhjklmnpqrstvwxyz])\1+/,
                       '\1' ],  # Remove doubled consonants except g.
                                # [PHP] add c to regexp.
    [ /^ae/,            'E' ],
    [ /^[gkp]n/,        'N' ],
    [ /^wr/,            'R' ],
    [ /^x/,             'S' ],
    [ /^wh/,            'W' ],
    [ /mb$/,            'M' ],  # [PHP] remove $ from regexp.
    [ /(?!^)sch/,      'SK' ],
    [ /th/,             '0' ],
    [ /t?ch|sh/,        'X' ],
    [ /c(?=ia)/,        'X' ],
    [ /[st](?=i[ao])/,  'X' ],
    [ /s?c(?=[iey])/,   'S' ],
    [ /[cq]/,           'K' ],
    [ /dg(?=[iey])/,    'J' ],
    [ /d/,              'T' ],
    [ /g(?=h[^aeiou])/, ''  ],
    [ /gn(ed)?/,        'N' ],
    [ /([^g]|^)g(?=[iey])/,
                      '\1J' ],
    [ /g+/,             'K' ],
    [ /ph/,             'F' ],
    [ /([aeiou])h(?=\b|[^aeiou])/,
                       '\1' ],
    [ /[wy](?![aeiou])/, '' ],
    [ /z/,              'S' ],
    [ /v/,              'F' ],
    [ /(?!^)[aeiou]+/,  ''  ],
  ]

  # Finds the Metaphone value for a word.  Note that only the letters A-Z are
  # supported, so any language-specific processing should be done beforehand.
  #
  def metaphone_word(w)
    # Normalise case and remove non-ASCII
    s = w.downcase.gsub(/[^a-z]/, '')
    # Apply the Metaphone rules
    RULES.each { |rx, rep| s.gsub!(rx, rep) }
    return s.upcase
  end

  # Finds the Metaphone values for a string containing multiple words by
  # calling metaphone_word.
  #
  def metaphone(str)
    return str.strip.split(/\s+/).map { |w| metaphone_word(w) }.join(' ')
  end

  extend self

end
end