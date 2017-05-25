require 'serverspec'
require 'docker-api'

def build_and_run_container(command = nil)
  @image = Docker::Image.build_from_dir('.', 'buildargs' => ["cache_date"=>"2017-04-08",
                                                                "config_timezone"=>"America/New_York",
                                                                "user_name"=>"phillipfry",
                                                                "user_id"=>"999",
                                                                "version_confd"=>"0.11.0",
                                                                "version_gosu"=>"1.10",
                                                                "version_smellbaron"=>"0.4.2",
                                                               ])
  set :os, family: :debian
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
