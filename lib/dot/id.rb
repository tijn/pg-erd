module Dot
  # An ID is one of the following:

  # Any string of alphabetic ([a-zA-Z\200-\377]) characters, underscores ('_') or digits ([0-9]), not beginning with a digit;
  # a numeral [-]?(.[0-9]+ | [0-9]+(.[0-9]*)? );
  # any double-quoted string ("...") possibly containing escaped quotes ('");
  # an HTML string (<...>).
  class Id
    def initialize(string)
      @string = string.to_s
      raise ArgumentError if @string.empty?
    end

    def escaped
      @string.gsub!("\"", "\\\"")
      @string.gsub!("\'", "\\\'")
      @string
    end

    def to_dot
      "\"#{escaped}\""
    end
  end
end
