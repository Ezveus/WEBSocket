module WEBSocket
  class Server

    if defined? Celluloid::IO
      UnderlyingServer = Celluloid::IO::TCPServer
    else
      UnderlyingServer = TCPSocket
    end
    
    def initialize hostname, port
      @server = UnderlyingServer.new hostname, port
    end

    def accept
      WEBSocket::Socket.from_underlying_socket @server.accept
    end

    def accept_nonblock
      Celluloid::IO::TCPSocket.from_ruby_socket @server.accept_nonblock
    end

    def to_io
      @server
    end

    # Are we inside a Celluloid ::IO actor?
    def evented?
      actor = Thread.current[:actor]
      actor && actor.mailbox.is_a?(Celluloid::IO::Mailbox)
    end
  end
end
