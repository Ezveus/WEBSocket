# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'WEBSocket/version'

Gem::Specification.new do |gem|
  gem.name          = "WEBSocket"
  gem.version       = WEBSocket::VERSION
  gem.date          = WEBSocket::DATE
  gem.authors       = ["Matthieu \"Ezveus\" Ciappara"]
  gem.email         = ["ciappam@gmail.com"]
  gem.description   = <<-EOS
Establish a websocket communication using Ruby standard sockets or Celluloid::IO sockets if required.
EOS
  gem.summary       = %q{Establish a websocket communication}
  gem.homepage      = "https://github.com/Ezveus/WEBSocket"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency 'websocket', '~> 1.0', '>= 1.0.6'
end
