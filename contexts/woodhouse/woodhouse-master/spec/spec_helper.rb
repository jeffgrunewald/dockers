require 'serverspec'
require 'docker'
require 'rspec/retry'

set :backend, :exec

def os_version
  command('cat /etc/lsb-release').stdout
end

def check_login
  command("curl -u $LOCAL_ADMIN:$LOCAL_PASSWORD --fail http://localhost:8080/")
end

def install_plugin
  command("java -jar /data/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin #{TEST_PLUGIN} --username ${LOCAL_ADMIN} --password ${LOCAL_PASSWORD}")
end
