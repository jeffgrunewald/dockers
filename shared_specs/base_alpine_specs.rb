require_relative './spec_helper'

shared_examples 'base::process' do
  describe process("/sbin/tini") do
    it { should be_running }
    its(:user) { should eq "root" }
    its(:pid) { should eq 1 }
  end
end

shared_examples 'base::packages' do
  ['ca-certificates', 'curl', 'git', 'iputils', 'vi'].each do |pkg|
    it pkg do
      apk_pkg pkg
    end
  end

  describe command('confd --version 2>&1') do
    its(:stdout) { should include 'confd 0.13.0' }
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
  describe command('cat /etc/alpine-release') do
    its(:stdout) { should match %r/^3.6.2$/ }
  end

  describe command('date') do
    its(:stdout) { should match %r/ E[SD]T / }
  end
end
