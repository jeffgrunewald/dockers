require 'serverspec'
require 'docker'
require 'rspec/retry'

set :backend, :exec

def os_version
  command('cat /etc/lsb-release').stdout
end
