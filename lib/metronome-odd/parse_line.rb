module ParseLine
  class Line
    @@line_regexp_hash = nil
    @help = false

    def remove_separators
      @line = @line.gsub(/\s+/, "")
    end

    def initialize(line)
      if @@line_regexp_hash.nil?
        @@line_regexp_hash = Hash.new([/^$/,/^$/])
      end
      @line = line
    end

    def Line.add_command(symbol, command)
      if @@line_regexp_hash.nil?
        @@line_regexp_hash = Hash.new([/^$/,[]])
      end
      @@line_regexp_hash[symbol] = command
    end
    
    def parse
      c = nil
      s = nil
      self.remove_separators
      @@line_regexp_hash.each do |symbol, command_regex|
        if @line.match(command_regex)
          c = @line.match(command_regex)
          s = symbol
          break
        end
      end
      [s, c]
    end
  end
end


