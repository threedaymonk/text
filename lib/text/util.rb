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
end
