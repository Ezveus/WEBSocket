if defined? Celluloid::IO
  require 'WEBSocket/Celluloid/socket'
else
  require 'socket'
  require 'WEBSocket/Standard/socket'
end
