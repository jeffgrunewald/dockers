require 'serverspec'
require 'docker'

set :backend, :exec

def os_version
  command('cat /etc/alpine-release').stdout
end

def apk_pkg pkg
  command("apk info #{pkg}").exit_status
end

def pypi_pkg pkg
  command("pip show #{pkg}").stdout
end
