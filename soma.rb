require 'tmpdir'

# Add Soma.new.start to your ~/.irbrc

class Soma
  def start
    Thread.start { tail }
  end

  def erase_and_open_buffer
    @file = File.open(File.join(Dir::tmpdir, "#{`whoami`.strip}_soma"), 'w+')
  end

  def tail
    erase_and_open_buffer
    loop do
      while (line = @file.read) && !line.empty?
        IRB::Irb.new(nil, @file.path).eval_input
        Readline::HISTORY.push(line.strip)
        erase_and_open_buffer
      end
      sleep 0.2
    end
  end
end
