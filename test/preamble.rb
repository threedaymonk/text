require 'test/unit'

lib = File.expand_path("../../lib")
$:.unshift lib unless $:.include?(lib)

class File
  def self.rel(*path)
    join(dirname(__FILE__), *path)
  end
end
