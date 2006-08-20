module Text
module Figlet

  class Smusher

    def initialize(font)
      @font = font
    end

    def [](result)
      todo = false

      @font.height.times do |j|
        result[j] = result[j].sub(pattern) { todo, x = callback(todo, $1, $2); x }
      end
      @font.height.times do |j|
        result[j] = if todo
          result[j].sub(/\s\x00(?!$)|\x00\s/, '').sub(/\x00(?!$)/, '')
        else
          result[j].sub(/\x00(?!$)/, '')
        end
      end
    end

    def pattern
      @pattern ||= /([^#{@font.hard_blank}\x00\s])\x00([^#{@font.hard_blank}\x00\s])/
    end

    def symbols
      @@symbols ||= {
        24 => '|/\\[]{}()<>',
        8 => {'[' => ']', ']' => '[', '{' => '}', '}' => '{', '(' => ')', ')' => '('},
        16 => {"/\\" => '|', "\\/" => 'Y', '><' => 'X'}
      }
    end

    def old_layout?(n)
      @font.old_layout & n > 0
    end

    def callback(s, a, b)
      combined = a + b
      
      if old_layout?(1) && a == b
        return true, a
      elsif old_layout?(2) && ('_' == a && symbols[24].include?(b) || '_' == b && symbols[24].include?(a))
        return true, a
      elsif old_layout?(4) && ((left = symbols[24].index(a)) && (right = symbols[24].index(b)))
        return true, (right > left ? b : a)
      elsif old_layout?(8) && (symbols[8].has_key?(b) && symbols[8][b] == a)
        return true, '|'
      elsif old_layout?(16) && symbols[16].has_key?(combined)
        return true, symbols[16][combined]
      elsif old_layout?(32) && (a == b && @font.hard_blank == a)
        return true, @font.hard_blank
      else
        return s, "#{a}\00#{b}"
      end
    end

  end

end # module Figlet
end # module Text