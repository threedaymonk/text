require File.join(File.dirname(__FILE__), 'preamble')

class FigletTest < Test::Unit::TestCase
  def test_hello_world
    font = Text::Figlet::Font.new(File.rel('data', 'big.flf'))
    figlet = Text::Figlet::Typesetter.new(font)
    assert_equal File.read(File.rel('data', 'figlet.txt')), figlet['Hello World']
  end
end