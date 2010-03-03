module Text
  def self.is_19?
    RUBY_VERSION[0, 3] == "1.9"
  end

  def self.encoding_of(string)
    if is_19?
      string.encoding.to_s
    else
      $KCODE
    end
  end

  def self.raise_19_incompat
    if is_19?
      raise "Text::Figlet is not compatible with Ruby 1.9 at this time"
    end
  end
end
