require "bundler/gem_tasks"

task :default => [:build]

def rake rule
  Process.fork do
    Process.exec 'rake', rule
  end
  Process.wait
end

task :standardServer do
  desc "Launch a echo server to make tests. Uses standard Ruby sockets"
  Dir.chdir 'test'
  rake "standardServer"
end

task :standardClient do
  desc "Launch a hello world client to make tests. Uses standard Ruby sockets"
  Dir.chdir 'test'
  rake "standardClient"
end

task :celluloidServer do
  desc "Launch a echo server to make tests. Uses Celluloid::IO sockets"
  Dir.chdir 'test'
  rake "celluloidServer"
end

task :celluloidClient do
  desc "Launch a hello world client to make tests. Uses Celluloid::IO sockets"
  Dir.chdir 'test'
  rake "celluloidClient"
end
