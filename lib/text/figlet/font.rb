module Text
module Figlet

  class UnknownFontFormat < StandardError
  end  

  class Font
    def initialize(filename, load_german = true)
      file = File.open(filename, 'rb')
  
      header = file.gets.strip.split(/ /)

      raise UnknownFontFormat if 'flf2a' != header[0][0, 5]

      @hard_blank = header.shift[-1, 1]
      @height = header.shift.to_i
      @baseline = header.shift
      @max_length = header.shift
      @old_layout = header.shift.to_i
      @comment_count = header.shift.to_i
      @right_to_left = header.shift
      @right_to_left = !@right_to_left.nil? && @right_to_left.to_i == 1
      
      @load_german, @characters = load_german, {}

      load_comments file
      load_ascii_characters file
      load_german_characters file
      load_extended_characters file
      
      file.close
    end

    def [](char)
      @characters[char]
    end
    
    def has_char?(char)
      @characters.has_key? char
    end

    attr_reader :height, :hard_blank, :old_layout
    
    def right_to_left?
      @right_to_left
    end


    private
    
    def load_comments(file)
      @comment_count.times { file.gets.strip }
    end
    
    def load_ascii_characters(file)
      (32..126).each { |i| @characters[i] = load_char(file) }
    end

    def load_german_characters(file)
      [91, 92, 93, 123, 124, 125, 126].each do |i|
        if @load_german
          unless char = load_char(file)
            return
          end
          @characters[i] = char
        else
          skip_char file
        end
      end
    end
    
    def load_extended_characters(file)
      until file.eof?
        i = file.gets.strip.split(/ /).first
        if i.empty?
          next
        elsif /^\-0x/i =~ i # comment
          skip_char file
        else
          if /^0x/i =~ i
            i = i[2, 1].hex
          elsif '0' == i[0] && '0' != i || '-0' == i[0, 2]
            i = i.oct
          end
          unless char = load_char(file)
            return
          end
          @characters[i] = char
        end
      end
    end
    
    def load_char(file)
      char = []
      @height.times do
        return false if file.eof?
        line = file.gets.rstrip
        if match = /(.){1,2}$/.match(line)
          line.gsub! match[1], ''
        end
        line << "\x00"
        char << line
      end
      return char      
    end

    def skip_char(file)
      @height.times do
        return if file.eof?
        return if file.gets.strip.nil?
      end
    end

  end

end # module Figlet
end # module Text