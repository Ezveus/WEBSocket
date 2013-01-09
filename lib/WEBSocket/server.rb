if defined? Celluloid::IO
  require 'WEBSocket/Celluloid/server'
else
  require 'socket'
  require 'WEBSocket/Standard/server'
end
