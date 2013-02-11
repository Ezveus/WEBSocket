module WEBSocket
  class Server < Base::Server
    extend Forwardable
    def_delegators :@server, :listen, :sysaccept, :close, :closed?, :addr

    def initialize hostname, port
      @server = Celluloid::IO::TCPServer.new hostname, port
    end

    def evented?
      @server.evented?
    end
  end
end
