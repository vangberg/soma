$:.unshift(File.join(File.dirname(__FILE__)))
require 'tmpdir'
require 'socket'
require 'soma/input_method'

Thread.abort_on_exception = true

class IRB::Irb
  attr_writer :context
end

class Soma
  def self.start(port=42000)
    if @soma
      puts "Soma already running.."
    else
      @some = new(port)
    end
  end

  def initialize(port)
    @irb = IRB.CurrentContext.irb
    @stdin_context = @irb.context
    @context = IRB::Context.new(@irb, @stdin_context.workspace, IRB::SomaInputMethod.new)

    @server = TCPServer.new('localhost', port)
    @thread = Thread.start { listen }
  end

  def listen
    while socket = @server.accept
      while lines = socket.gets("EOF\r\n").split("\r\n")
        lines.pop
        @context.io.puts lines
        @irb.context = @context
        @irb.eval_input
        @irb.context = @stdin_context
        print IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_N]
      end
    end
  end
end
