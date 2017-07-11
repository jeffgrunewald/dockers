require 'spec_helper'

image_name = 'base-alpine'
env_vars = {}
backend = :alpine
command = {'Cmd' => ["gosu", "phillipfry", "ping", "8.8.8.8"]}
timezone = 'America/New_York'

describe "Dockerfile" do
  before(:all) do
    build_and_run_container(backend, command)
  end

  after(:all) do
    stop_and_remove_container
  end

  describe 'base specs' do
    include_examples 'base::process'
    include_examples 'base::packages'
    include_examples 'base::files', image_name, env_vars
    include_examples 'base::config', timezone
  end

  describe process("ping") do
    its(:args) { should match "8.8.8.8" }
  end

end
