$:.unshift '../lib'

require 'WEBSocket'

Host = '127.0.0.1'
Port = 4242
Size = 4096

Signal.trap "INT" do
  puts "\rExiting"
  exit 0
end

server = WEBSocket::Server.new Host, Port
$stderr.puts "==> Server was created : #{server}[#{Host}:#{Port}]"
client = server.accept
$stderr.puts "==> AcceptedSocket was created : #{client}"
_, port, host = client.peeraddr
$stderr.puts "==> Received connection from #{host}:#{port}"
loop do
  s = nil
  begin
    s = client.readpartial Size
  rescue EOFError
    break
  end
  break if s.nil? or s == ""
  $stderr.puts "==> Read #{s}"
  client.write s
  $stderr.puts "==> Written #{s}"
end
