require 'spec_helper'

JENKINS_VERSION='2.60.2'
JENKINS_HOME='/data/jenkins'
JAVA_HOME='/usr/lib/jvm/open-jdk'
ENV_VARS = {
  'JENKINS_HOME' => "#{JENKINS_HOME}",
  'JENKINS_AGENT_PORT' => 50000,
  'JENKINS_UC' => 'https://updates.jenkins.io',
  'LOG_LEVEL' => 'INFO',
}
PORTS = [ '8080', '50000' ]
PLUGIN_LIST = [ 'job-dsl', 'simple-theme-plugin', 'pipeline-build-step'  ]
TEST_PLUGIN = 'gerrit-trigger'

describe 'Dockerfile' do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')
    set :os, family: :debian
    set :backend, :docker
    set :docker_container, 'spec_container'
    @container = Docker::Container.create(
      'Image' => @image.id,
      'name' => 'spec_container',
      'Env' => ["LOCAL_ADMIN=homer"],
    )
    @container.start
  end

  after(:all) do
    @container.kill
    @container.delete(:force => true)
  end

  it 'installs the right version of Ubuntu' do
    expect(os_version).to include('Ubuntu 16')
  end

  context 'environment variables' do
    ENV_VARS.each_pair do |key, value|
      it "default set for #{key}" do
        expect(@image.json["Config"]["Env"]).to include("#{key}=#{value}")
      end unless value.nil?
    end
  end

  it 'installs required packages' do
    expect(package('apt-utils')).to be_installed
    expect(package('git')).to be_installed
    expect(package('openjdk-8-jdk')).to be_installed
  end

  it "should create #{JENKINS_HOME}/jobs volume" do
    expect(@image.json["Config"]["Volumes"]).to include("#{JENKINS_HOME}/jobs")
  end

  context 'expose ports' do
    PORTS.each do |port|
      it "should expose port #{port}" do
        expect(@container.json["Config"]["ExposedPorts"]).to include("#{port}/tcp")
      end
    end
  end

  it "should have a health check" do
    expect(@image.json["ContainerConfig"]["Healthcheck"]["Test"][1]).to include("curl")
  end

  context 'listening ports' do
    PORTS.each do |port|
      describe port "#{port}" do
        it 'should be listening', :retry => 15, :retry_wait => 3 do
          expect(port("#{port}")).to be_listening
        end
      end
    end
  end

  describe user 'woodhouse' do
    it { should exist }
    it { should belong_to_group 'woodhouse' }
  end

  describe process 'java' do
    it 'should be_running', :retry => 15, :retry_wait => 3 do
      should be_running
    end
    its(:user) { should eq 'woodhouse' }
    describe file "#{JENKINS_HOME}/config.xml" do
      it 'should be_file', :retry => 15, :retry_wait => 3 do
        should be_file
      end
      its(:content) { should match Regexp.escape('authorizationStrategy')}
    end
  end

  it 'copies config files into place' do
    expect(file("#{JENKINS_HOME}/org.codefirst.SimpleThemeDecorator.xml")).to exist
    expect(file('/opt/README-woodhouse.md')).to exist
    expect(file('/opt/Dockerfile-woodhouse')).to exist
    expect(file('/opt/plugins.txt')).to exist
    expect(file("#{JENKINS_HOME}/init.groovy.d/config.groovy")).to exist
    expect(file("#{JENKINS_HOME}/init.groovy.d/local-user.groovy")).to exist
    expect(file("#{JENKINS_HOME}/init.groovy.d/tcp-slave-agent-port.groovy")).to exist
    expect(file('/usr/local/bin/install-plugins.sh')).to exist
    expect(file('/usr/local/bin/jenkins-support')).to exist
    expect(file('/usr/share/jenkins/jenkins.war')).to exist
  end

  describe 'Files generated to disable setup wizard' do
    describe file "#{JENKINS_HOME}/jenkins.install.InstallUtil.lastExecVersion" do
      it { should be_file }
      its(:content) { should eq "#{JENKINS_VERSION}\n" }
    end

    describe file "#{JENKINS_HOME}/jenkins.install.UpgradeWizard.state" do
      it { should be_file }
      its(:content) { should eq "#{JENKINS_VERSION}\n"}
    end
  end

  context 'all defined plugins exist' do
    File.open('plugins.txt').each do |line|
      (pluginname,version)=line.split /\s|:/
      describe file "#{JENKINS_HOME}/plugins/#{pluginname}.jpi" do
        it { should be_file }
      end
    end
  end

  context 'user configuration' do
    it 'installs a default admin user' do
      expect(file('/data/jenkins/users/homer')).to be_directory
    end

    it 'serves the web UI and restricts access by user' do
      expect(check_login.exit_status).to eq 0
    end

    it 'installs remote plugins by elevated user credentials' do
      expect(install_plugin.exit_status).to eq 0
      expect(file("/data/jenkins/plugins/#{TEST_PLUGIN}.jpi")).to be_file
    end
  end

  context 'seed job' do
    xit 'runs the seed job and creates the remote jobs', :retry => 15, :retry_wait => 2 do
      expect(file("/var/lib/jenkins/jobs/Hi\ everybody")).to be_directory
    end
  end
end
