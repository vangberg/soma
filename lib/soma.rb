require 'tmpdir'

class IRB::Irb
  attr_writer :context
end

module Soma
  extend self
  def start
    @thread || @thread = Thread.start { tail }
  end

  def erase_and_open_buffer
    @file = File.open(File.join(Dir::tmpdir, "#{`whoami`.strip}_somarepl_buffer"), 'w+')
  end

  def tail
    erase_and_open_buffer
    loop do
      while (line = @file.readlines) && !line.empty?
        line.each {|l| Readline::HISTORY.push(l.strip) }
        # Get the current IRB
        irb = IRB.CurrentContext.irb
        # We save the IRB context that takes STDIN as input
        stdin_context = irb.context
        # .. replace it with a context that takes our buffer file as input
        irb.context = IRB::Context.new(irb, stdin_context.workspace, @file.path)
        irb.eval_input
        # and finally puts back the STDIN context so control is handled back to the IRB session again
        irb.context = stdin_context
        erase_and_open_buffer
      end
      sleep 0.2
    end
  end
end
