module WEBSocket
  class Socket < Base::Socket
    extend Forwardable
    attr_reader :status

    def_delegators :@socket, :close, :closed?
    def_delegators :@socket, :addr, :peeraddr, :setsockopt

    def acquire_ownership type
      @socket.acquire_ownership type
    end

    def evented?
      @socket.evented?
    end

    def initialize rhost, rport, lhost = nil, lport = nil
      @status = :disconnected
      @socket = Celluloid::IO::TCPSocket.new rhost, rport, lhost, lport
      connect rhost, rport
    end

    def release_ownership type
      @socket.release_ownership type
    end

    def wait_readable
      @socket.wait_readable
    end

    def wait_writable
      @socket.wait_writable
    end
  end
end
