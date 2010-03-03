require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

class File
  def self.rel(*path)
    join(dirname(__FILE__), *path)
  end
end
