require 'text/double_metaphone'
require 'text/figlet'
require 'text/levenshtein'
require 'text/metaphone'
require 'text/porter_stemming'
require 'text/soundex'
require 'text/version'

module Text
  def self.encoding_of(string)
    if defined?(Encoding) 
      string.encoding.to_s 
    else 
      $KCODE
    end
  end
end