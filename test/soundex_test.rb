require_relative "./test_helper"
require "text/soundex"
require 'yaml'

class SoundexTest < Test::Unit::TestCase

  def test_cases
    YAML.load(data_file('soundex.yml')).each do |input, expected_output|
      assert_equal expected_output, Text::Soundex.soundex(input)
    end
  end

end
