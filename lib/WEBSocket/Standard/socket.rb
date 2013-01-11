module WEBSocket
  class Socket
    extend Forwardable
    attr_reader :status

    def_delegators :@socket, :close, :closed?
    def_delegators :@socket, :addr, :peeraddr, :setsockopt

    def acquire_ownership type
    end

    def connect host, port
      @handshake = WebSocket::Handshake::Client.new :url => "ws://#{host}:#{port}"
      @socket.write @handshake.to_s
      msg = @socket.readpartial 4096
      @handshake << msg
      @status = :connected
    end

    def evented?
      false
    end

    def initialize rhost, rport, lhost = nil, lport = nil
      @status = :disconnected
      @socket = TCPSocket.new rhost, rport, lhost, lport
      connect rhost, rport
    end

    def read length = nil, buffer = nil
      s = @socket.read length, buffer
      frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
      frame << s
      frame.to_s
    end

    def read_nonblock length, buffer = nil
      buffer ||= ''
      
      @socket.read_nonblock length, buffer
      frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
      frame << buffer
      frame.to_s
    end

    def readpartial length, buffer = nil
      s = @socket.readpartial length, buffer
      frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
      frame << s
      frame.to_s
    end

    def release_ownership type
    end

    def to_io
      @socket
    end

    def wait_readable
    end

    def wait_writable
    end

    def write s
      frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => s, :type => :text
      @socket.write frame.to_s
    end

    def write_nonblock s
      frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => s, :type => :text
      @socket.write_nonblock frame.to_s
    end

    def << s
      frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => s, :type => :text
      @socket << frame.to_s
    end
  end
end
