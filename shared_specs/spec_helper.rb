require 'serverspec'
require 'docker-api'

def build_and_run_container(backend, command = nil)
  @image = Docker::Image.build_from_dir('.')
  set :os, family: backend
  set :backend, :docker
  set :docker_container, 'test_container'

  run_config = { 'Image' => @image.id, 'name' => 'test_container', }
  run_config.merge!(command) unless command.nil?
  @container = Docker::Container.create(run_config)
  @container.start
end

def stop_and_remove_container
  @container.kill
  @container.delete(:force => true)
end

def apk_pkg pkg
  command("apk info #{pkg}").exit_status
end