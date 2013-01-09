# WEBSocket

Establish a websocket communication using Ruby standard sockets or
[Celluloid::IO](http://github.com/celluloid/celluloid-io) sockets if
required.

## Installation

Add this line to your application's Gemfile:

    gem 'WEBSocket'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install WEBSocket

## Usage


### WEBSocket::Socket

This socket is a Ruby standard socket unless 'celluloid/io' has been
required. In both cases, WEBSocket::Socket works as a wrapper of Ruby
standard socket module.

```ruby
require 'WEBSocket'

s = WEBSocket::Socket.new 'localhost', 4242
s.write "Ping"
pong = s.readpartial 4096
```

### WEBSocket::server

This server is a Ruby standard server unless 'celluloid/io' has been
required. In both cases, WEBSocket::Server works as a wrapper of Ruby
standard socket module.

Here is a standard echoserver

```ruby
require 'celluloid/io'
require 'WEBSocket'

class EchoServer
  include Celluloid::IO

  def initialize host, port
    puts "*** Starting echo server on #{host}:#{port}"

    @server = WEBSocket::Server.new host, port
    run!
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { handle_connection! @server.accept }
  end

  def handle_connection socket
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"
    loop { socket.write socket.readpartial 4096 }
  rescue EOFError
    puts "*** #{host}:#{port} disconnected"
    socket.close
  end
end

supervisor = EchoServer.supervise("127.0.0.1", 1234)
trap("INT") { supervisor.terminate; exit }
sleep
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
