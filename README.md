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
required. In both cases, WEBSocket::Socket works as a wrapper of Celluloid::IO::TCPSocket

```ruby
require 'WEBSocket'

s = WEBSocket::Socket.new 'localhost', 4242
s.write "Ping"
pong = s.readpartial 4096
```

### WEBSocket::server

TODO : code and write a description

```ruby
puts "TODO"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
