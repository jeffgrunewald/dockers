require 'spec_helper'

shared_examples 'base::process' do
  describe process("smell-baron") do
    its(:user) { should eq "root" }
    its(:pid) { should eq 1 }
  end
end

shared_examples 'base::packages' do
  it 'installs the correct packages' do
    expect(package('curl')).to be_installed
    expect(package('dnsutils')).to be_installed
    expect(package('iputils-ping')).to be_installed
    expect(package('less')).to be_installed
    expect(package('strace')).to be_installed
    expect(package('telnet')).to be_installed
    expect(package('vim')).to be_installed
  end

  describe command('which vi') do
    its(:stdout) { should match '/usr/bin/vi' }
  end

  describe command('confd --version 2>&1') do
    its(:stdout) { should include 'confd 0.11.0' }
  end

  describe command('gosu --version 2>&1') do
    its(:stdout) { should include 'version: 1.10' }
  end
end

shared_examples 'base::files' do |image_name, env_vars|
  describe file('/tmp') do
    it { should exist }
    it { should be_directory }
    it { should be_mode '1777' }
  end

  describe file("/opt/Dockerfile-#{image_name}") do
    it { should be_file }
    it { should be_readable }
    its(:content) { should match File.read('Dockerfile') }
  end

  describe file("/opt/README-#{image_name}.md") do
    it { should be_file }
    it { should be_readable }
    its(:content) { should match File.read('README.md') }
    env_vars.each_key do |var|
      its(:content) { should match Regexp.escape(var) }
    end
  end
end

shared_examples 'base::config' do |time_zone|
  describe command('cat /etc/lsb-release') do
    its(:stdout) { should include 'Ubuntu 16' }
  end

  describe file('/etc/timezone') do
    it { should be_file }
    its(:content) { should match "#{time_zone}" }
  end
end
