module WEBSocket
    class Server
    extend Forwardable
    def_delegators :@server, :listen, :sysaccept, :close, :closed?, :addr

    class AcceptedSocket
      extend Forwardable
      attr_reader :status

      def_delegators :@socket, :close, :closed?
      def_delegators :@socket, :addr, :peeraddr, :setsockopt

      def acquire_ownership type
        @socket.acquire_ownership type
      end

      def connect
        @handshake = WebSocket::Handshake::Server.new
        msg = @socket.readpartial 4096
        @handshake << msg
        until @handshake.finished?
          msg = @socket.readpartial 4096
          @handshake << msg
        end
        if @handshake.valid?
          @socket.write @handshake.to_s
          @status = :connected
        end
        self
      end

      def evented?
        false
      end

      def initialize socket
        @socket = socket
        @status = :disconnected
      end

      def read length = nil, buffer = nil
        s = @socket.read length, buffer
        frame = WebSocket::Frame::Incoming::Server.new :version => @handshake.version
        frame << s
        frame.next.to_s
      end

      def read_nonblock length, buffer = nil
        buffer ||= ''

        s = @socket.read length, buffer
        frame = WebSocket::Frame::Incoming::Server.new :version => @handshake.version
        frame << s
        frame.next.to_s
      end

      def readpartial length, buffer = nil
        s = @socket.readpartial length, buffer
        frame = WebSocket::Frame::Incoming::Server.new :version => @handshake.version
        frame << s
        frame.next.to_s
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
        frame = WebSocket::Frame::Outgoing::Server.new :version => @handshake.version, :data => s, :type => :text
        @socket.write frame.to_s
      end

      def write_nonblock s
        frame = WebSocket::Frame::Outgoing::Server.new :version => @handshake.version, :data => s, :type => :text
        @socket.write_nonblock frame.to_s
      end

      def << s
        frame = WebSocket::Frame::Outgoing::Server.new :version => @handshake.version, :data => s, :type => :text
        @socket << frame.to_s
      end
    end

    def initialize hostname, port
      @server = TCPServer.new hostname, port
    end

    def accept
      AcceptedSocket.new(@server.accept).connect
    end

    def accept_nonblock
      AcceptedSocket.new(@server.accept_nonblock).connect
    end

    def to_io
      @server
    end

    def evented?
      false
    end
  end
end
