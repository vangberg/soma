require 'tmpdir'

class Soma
  def initialize
    Thread.start { tail }
  end

  def tail
    begin
    @file = File.open(File.join(Dir::tmpdir, "#{`whoami`.strip}_soma"), 'w+')
      loop do
        while (line = @file.read) && !line.empty?
          Readline::HISTORY.push(line.strip)
          IRB::Irb.new(nil, @file.path).eval_input
          @file = File.open(File.join(Dir::tmpdir, "#{`whoami`.strip}_soma"), 'w+')

        end
        sleep 1
      end
    end
  end
end
