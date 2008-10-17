require 'tmpdir'

class IRB::Irb
  attr_writer :context
end

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
        irb = IRB.CurrentContext.irb
        stdin_context = irb.context
        puts `cat #{@file.path}`
        irb.context = IRB::Context.new(irb, stdin_context.workspace, @file.path)
        irb.eval_input
        irb.context = stdin_context
        erase_and_open_buffer
      end
      sleep 0.2
    end
  end
end
