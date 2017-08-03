require 'spec_helper'

ENV_VARS = { }
PORTS=['22']
AUTHORIZED_KEYS='something goes here'

describe 'Dockerfile' do

  before(:all) do
    @image = Docker::Image.build_from_dir('.')
    set :os, family: :debian
    set :backend, :docker
    set :docker_container, 'test_container'
    @container = Docker::Container.create(
      'Image' => @image.id,
      'name' => 'test_container',
      'Env' => ["AUTHORIZED_KEYS=#{AUTHORIZED_KEYS}"],
    )
    @container.start
  end

  after(:all) do
    @container.kill
    @container.delete(:force => true)
  end

  describe command('cat /etc/lsb-release') do
    its(:stdout) { should include 'Ubuntu 16' }
  end

  context 'ports' do
    PORTS.each do |port|
      it "exposes port #{port}" do
        expect(@container.json["Config"]["ExposedPorts"]).to include("#{port}/tcp")
      end
    end
  end

  describe process 'smell-baron' do
    it { should be_running }
    its(:user) { should eq 'root' }
    its(:pid) { should eq 1 }
  end

  context 'authorized keys' do
    describe file '/home/woodhouse/.ssh' do
      it { should be_directory }
      it { should be_mode '700' }
      it { should be_owned_by 'woodhouse' }
      it { should be_grouped_into 'woodhouse' }
    end
    describe file '/home/woodhouse/.ssh/authorized_keys' do
      it { should be_file }
      it { should be_mode '600' }
      it { should be_owned_by 'woodhouse' }
      it { should be_grouped_into 'woodhouse' }
      its(:content) { should eq "#{AUTHORIZED_KEYS}\n" }
    end
  end

  describe file '/opt/Dockerfile-woodhouse-agent' do
    it { should be_file }
    its(:content) { should match File.read('Dockerfile') }
  end

  describe file '/opt/README-woodhouse-agent.md' do
    it { should be_file }
    its(:content) { should match File.read('README.md') }
    ENV_VARS.each_key do |var|
      its(:content) { should match Regexp.escape(var) }
    end
    PORTS.each do |port|
      its(:content) { should match Regexp.escape(port) }
    end
  end
end
