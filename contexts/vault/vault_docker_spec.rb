require_relative '../../shared_specs/spec_helper'
require_relative '../../shared_specs/base_ubuntu_specs'

image_name = 'vault'
environment = {'Env' => ['VAULT_LOCAL_CONFIG={"listener":[{"tcp":{"address":"127.0.0.1:8200","tls_disable":"1"}}],"storage":{"inmem":{}},"disable_mlock":"true"}']}
backend = :debian
timezone = 'America/New_York'

describe 'Vault docker' do

  before(:all) do
    build_and_run_container(backend, environment)
  end

  after(:all) do
    stop_and_remove_container
  end

  describe 'base specs' do
    include_examples 'base::process'
    include_examples 'base::packages'
    include_examples 'base::files', image_name
    include_examples 'base::config', timezone
  end

  context 'vault specs' do
    it 'exposes port 8200', :retry => 5, :retry_wait => 10 do
      expect(port(8200)).to be_listening
    end

    it 'should install vault-supporting packages' do
      expect(package('jq')).to be_installed
      expect(package('openssl')).to be_installed
      expect(package('supervisor')).to be_installed
    end

    describe file "/vault/config/local.json" do
      it { should be_file }
      its(:content) { should include "inmem" }
    end

    describe process 'vault' do
      it 'should be_running' do
        should be_running
      end
      its(:user) { should eq 'phillipfry' }
    end

    it 'unseals the vault', :retry => 5, :retry_wait => 15 do
      expect(command('vault status -address=http://127.0.0.1:8200').exit_status).to eq(0)
      expect(command('vault status -address=http://127.0.0.1:8200').stdout).to match(/Sealed: false/)
    end

  end
end