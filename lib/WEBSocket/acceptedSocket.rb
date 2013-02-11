module WEBSocket
  module Base
    class AcceptedSocket
      def acquire_ownership type
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

      def from_frame_to_text str
        frame = WebSocket::Frame::Incoming::Server.new :version => @handshake.version
        frame << str
        frame.next.to_s
      end

      def from_text_to_frame str
        frame = WebSocket::Frame::Outgoing::Server.new :version => @handshake.version, :data => str, :type => :text
        frame.to_s
      end

      def read length = nil, buffer = nil
        s = @socket.read length, buffer
        from_frame_to_text s
      end

      def read_nonblock length, buffer = nil
        buffer ||= ''

        @socket.read_nonblock length, buffer
        from_frame_to_text buffer
      end

      def readpartial length, buffer = nil
        s = @socket.readpartial length, buffer
        from_frame_to_text s
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
        s2 = from_text_to_frame(s)
        @socket.write s2
      end

      def write_nonblock s
        @socket.write_nonblock from_text_to_frame(s)
      end

      def << s
        @socket << from_text_to_frame(s)
      end
    end
  end
end

if defined? Celluloid::IO
  require 'WEBSocket/Celluloid/acceptedSocket'
else
  require 'socket'
  require 'WEBSocket/Standard/acceptedSocket'
end
