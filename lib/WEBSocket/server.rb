module WEBSocket
  module Base
    class Server
      def accept
        WEBSocket::AcceptedSocket.new(@server.accept).connect
      end

      def accept_nonblock
        WEBSocket::AcceptedSocket.new(@server.accept_nonblock).connect
      end

      def to_io
        @server
      end

      def evented?
        false
      end
    end
  end
end

if defined? Celluloid::IO
  require 'WEBSocket/Celluloid/server'
else
  require 'socket'
  require 'WEBSocket/Standard/server'
end
