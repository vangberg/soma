require 'tmpdir'

# Add Soma.new.start to your ~/.irbrc

class Soma
  def start
    Thread.start { tail }
  end

  def erase_and_open_buffer
    @file = File.open(File.join(Dir::tmpdir, "#{`whoami`.strip}_somarepl_buffer"), 'w+')
  end

  def tail
    erase_and_open_buffer
    loop do
      while (line = @file.readlines) && !line.empty?
        line.each {|l| Readline::HISTORY.push(l.strip) }
        IRB::Irb.new(nil, @file.path).eval_input
        erase_and_open_buffer
      end
      sleep 0.2
    end
  end
end
