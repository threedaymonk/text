#
# Ruby implementation of the Figlet program (http://www.figlet.org/).
#
# Author: Tim Fletcher (twoggle@gmail.com)
#
# Usage:
#
#   big_font = Text::Figlet::Font.new('big.flf')
#
#   figlet = Text::Figlet::Typesetter.new(big_font)
#
#   puts figlet['hello world']
#
#
require 'text/figlet/font'
require 'text/figlet/smusher'
require 'text/figlet/typesetter'
