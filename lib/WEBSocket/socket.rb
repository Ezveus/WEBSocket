module WEBSocket
  class Socket
    attr_reader :status

    def self.from_ruby_socket rbsock
      if defined? Celluloid::IO
        csock = Celluloid::IO::TCPSocket.from_ruby_socket rbsock
      else
        csock = rbsock
      end
      Websocket.new csock
    end

    def acquire_ownership type
      @socket.acquire_ownership type
    end

    def close
      @socket.close
    end

    def connect host, port
      @handshake = WebSocket::Handshake::Client.new :url => "ws://#{host}:#{port}"
      @socket.write @handshake.to_s
      msg = @socket.readpartial 4096
      @handshake << msg
      @status = :connected
    end

    def evented?
      @socket.evented?
    end

    def initialize host, port
      @status = :disconnected
      @socket = Celluloid::IO::TCPSocket.new host, port
      connect host, port
    end

    def read length = nil, buffer = nil
      s = @socket.read length, buffer
      frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
      frame << s
      frame.to_s
    end

    def readpartial length, buffer = nil
      s = @socket.readpartial length, buffer
      frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
      frame << s
      frame.to_s
    end

    def release_ownership type
      @socket.release_ownership type
    end

    def to_io
      @socket
    end

    def wait_readable
      @socket.wait_readable
    end

    def wait_writable
      @socket.wait_writable
    end

    def write s
      frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => s, :type => :text
      @socket.write frame.to_s
    end

    def << s
      frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => s, :type => :text
      @socket << frame.to_s
    end
  end
end
