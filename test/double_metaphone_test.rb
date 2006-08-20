require File.join(File.dirname(__FILE__), 'preamble')
require 'rubygems'
require 'fastercsv'  

class DoubleMetaphoneTest < Test::Unit::TestCase

  def test_cases
    FasterCSV.read(File.rel('data', 'double_metaphone.csv'), :col_sep => ', ').each_with_index do |row, i|
      primary, secondary = Text::DoubleMetaphone[row[0]]

      assert_equal row[1], primary
      assert_equal row[2], secondary.nil?? primary : secondary
    end
  end

end
