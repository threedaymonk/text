# 
# An implementation of the Metaphone phonetic coding system in Ruby.
# 
# Metaphone encodes names into a phonetic form such that similar-sounding names
# have the same or similar Metaphone encodings.
# 
# The original system was described by Lawrence Philips in Computer Language
# Vol. 7 No. 12, December 1990, pp 39-43.
# 
# As there are multiple implementations of Metaphone, each with their own
# quirks, I have based this on my interpretation of the algorithm specification.
# Even LP's original BASIC implementation appears to contain bugs (specifically
# with the handling of CC and MB), when compared to his explanation of the
# algorithm.
# 
# I have also compared this implementation with that found in PHP's standard
# library, which appears to mimic the behaviour of LP's original BASIC
# implementation. For compatibility, these rules can also be used by passing
# :buggy=>true to the methods.
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
                                # [PHP] remove c from regexp.
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
  
  # The rules for the 'buggy' alternate implementation used by PHP etc.
  #
  BUGGY_RULES = RULES.dup
  BUGGY_RULES[0] = [ /([bdfhjklmnpqrstvwxyz])\1+/, '\1' ]
  BUGGY_RULES[6] = [ /mb/, 'M' ]

  # Finds the Metaphone value for a word.  Note that only the letters A-Z are
  # supported, so any language-specific processing should be done beforehand.
  #
  # If the :buggy option is set, buggy rules are used.
  #
  def metaphone_word(w, options={})
    # Normalise case and remove non-ASCII
    s = w.downcase.gsub(/[^a-z]/, '')
    # Apply the Metaphone rules
    rules = options[:buggy] ? BUGGY_RULES : RULES
    rules.each { |rx, rep| s.gsub!(rx, rep) }
    return s.upcase
  end

  # Finds the Metaphone values for a string containing multiple words by
  # calling metaphone_word for each.
  #
  # If the :buggy option is set, buggy rules are used.
  #
  def metaphone(str, options={})
    return str.strip.split(/\s+/).map { |w| metaphone_word(w, options) }.join(' ')
  end

  extend self

end
end