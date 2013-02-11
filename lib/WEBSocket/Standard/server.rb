module WEBSocket
  class Server < Base::Server
    extend Forwardable
    def_delegators :@server, :listen, :sysaccept, :close, :closed?, :addr

    def initialize hostname, port
      @server = TCPServer.new hostname, port
    end
  end
end
