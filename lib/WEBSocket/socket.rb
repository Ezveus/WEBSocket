module WEBSocket
  module Base
    class Socket
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

      def from_frame_to_text str
        frame = WebSocket::Frame::Incoming::Client.new :version => @handshake.version
        frame << str
        frame.next.to_s
      end

      def from_text_to_frame str
        frame = WebSocket::Frame::Outgoing::Client.new :version => @handshake.version, :data => str, :type => :text
        frame.to_s
      end

      def read length = nil, buffer = nil
        s = nil
        if length
          if length.kind_of? Numeric
            s = @socket.read length + 4, buffer
          elsif buffer.nil?
            s = @socket.read nil, length
          end
        else
          s = @socket.read nil, nil
        end
        from_frame_to_text s
      end

      def read_nonblock length, buffer = nil
        buffer ||= ''

        @socket.read_nonblock length + 4, buffer
        from_frame_to_text buffer
      end

      def readpartial length, buffer = nil
        s = @socket.readpartial length + 4, buffer
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
        @socket.write from_text_to_frame(s.to_s)
      end

      def write_nonblock s
        @socket.write_nonblock from_text_to_frame(s.to_s)
      end

      def << s
        @socket << from_text_to_frame(s.to_s)
      end
    end
  end
end

if defined? Celluloid::IO
  require 'WEBSocket/Celluloid/socket'
else
  require 'socket'
  require 'WEBSocket/Standard/socket'
end
