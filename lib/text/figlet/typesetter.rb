module Text
module Figlet

  class Typesetter

    def initialize(font, options = nil)
      @font = font
      @options = options || {}
      @smush = @options.has_key?(:smush) ? @options[:smush] : true
    end

    def [](str)
      result = []
      str.length.times do |i|
        char = str[i]
        unless @font.has_char?(char)
          if @font.has_char?(0)
            char = 0
          else
            next
          end
        end
        @font.height.times do |j|
          line = @font[char][j]
          if result[j].nil?
            result[j] = line
          else
            result[j] = @font.right_to_left?? (line + result[j]) : (result[j] + line)
          end
        end
        if @font.old_layout > -1 && i > 0
          diff = -1
          @font.height.times do |j|
            if match = /\S(\s*\x00\s*)\S/.match(result[j])
              len = match[1].length
              diff = (diff == -1 ? len : min(diff, len))
            end
          end
          diff -= 1
          if diff > 0
            @font.height.times do |j|
              if match = /\x00(\s{0,#{diff}})/.match(result[j])
                b = diff - match[1].length
                result[j] = result[j].sub(/\s{0,#{b}}\x00\s{#{match[1].length}}/, "\0")
              end
            end
          end
          smush[result] if @smush
        end
      end
      return result.join("\n").gsub(/\0/, '').gsub(@font.hard_blank, ' ')
    end


    private

    def min(a, b)
      a > b ? b : a
    end

    def smush
      @smusher ||= Smusher.new(@font)
    end

  end

end # module Figlet
end # module Text