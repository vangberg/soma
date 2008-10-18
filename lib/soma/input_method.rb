module IRB
  class SomaInputMethod < IRB::InputMethod
    attr_reader :buffer
    attr_accessor :prompt
    def initialize
      super
      @buffer = []
    end

    def eof?
      @buffer.empty?
    end

    def gets
      while line = @buffer.shift
        next if /^\s+$/ =~ line
        line.concat "\n"
        print @prompt, line
        Readline::HISTORY.push(line)
        break
      end
      line
    end

    def puts(lines)
      @buffer.concat lines
    end
  end
end
