$:.unshift '../lib'

require 'celluloid/io'
require 'WEBSocket'

Host = '127.0.0.1'
Port = 4242
Size = 4096

client = WEBSocket::Socket.new Host, Port
$stderr.puts "==> Client was created : #{client}[#{Host}:#{Port}]"
s = "Hello World"
client.write s
$stderr.puts "==> Written #{s}"
s2 = client.readpartial Size
$stderr.puts "==> Read #{s2}"
