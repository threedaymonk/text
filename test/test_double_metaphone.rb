require File.join(File.dirname(__FILE__), 'preamble')
require "text/double_metaphone"

require 'csv'

class DoubleMetaphoneTest < Test::Unit::TestCase

  def test_cases
    CSV.open(File.rel('data', 'double_metaphone.csv'), 'r').to_a.each do |row|
      primary, secondary = Text::Metaphone.double_metaphone(row[0])

      assert_equal row[1], primary
      assert_equal row[2], secondary.nil?? primary : secondary
    end
  end

end
