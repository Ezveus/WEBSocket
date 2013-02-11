module WEBSocket
  class AcceptedSocket < Base::AcceptedSocket
    extend Forwardable
    attr_reader :status

    def_delegators :@socket, :close, :closed?
    def_delegators :@socket, :addr, :peeraddr, :setsockopt

    def initialize socket
      @socket = socket
      @status = :disconnected
    end
  end
end
