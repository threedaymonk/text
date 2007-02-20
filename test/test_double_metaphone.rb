require File.join(File.dirname(__FILE__), 'preamble')

begin
  require 'rubygems' rescue nil
  require 'fastercsv'
  METHOD = [ FasterCSV, :foreach, { :col_sep => ', ' } ]
rescue LoadError
  require 'csv'
  METHOD = [ CSV, :open, 'r', ', ' ]
end

class DoubleMetaphoneTest < Test::Unit::TestCase

  def test_cases
    METHOD.shift.send(METHOD.shift, File.rel('data', 'double_metaphone.csv'), *METHOD) do |row|
      primary, secondary = Text::Metaphone.double_metaphone(row[0])

      assert_equal row[1], primary
      assert_equal row[2], secondary.nil?? primary : secondary
    end
  end

end
