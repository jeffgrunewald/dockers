require 'spec_helper.rb'

APK_PKGS = ['ca-certificates', 'gcc', 'linux-headers', 'musl-dev', 'python-dev', 'py-pip', 'py-setuptools']

ENV_VARS = {
  'OS_AUTH_URL' => 'http://172.16.0.1:5000/v3',
  'OS_CMD' => 'openstack server list',
  'OS_NO_CACHE' => '1',
  'OS_PASSWORD' => 'password',
  'OS_PROJECT_DOMAIN_NAME' => 'Default',
  'OS_PROJECT_NAME' => 'tenant',
  'OS_REGION_NAME' => 'RegionOne',
  'OS_USER_DOMAIN_NAME' => 'Default',
  'OS_USERNAME' => 'userId'
}

describe 'Dockerfile' do
  let(:image) { Docker::Image.build_from_dir('./mk2') }
  let(:container) { Docker::Container.create('Image' => image.id, 'name' => 'spec_container2', ) }

  before(:each) do
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
    @envs = Hash[container.json['Config']['Env'].map {|env_var| env_var.split '=', 2}]
  end
 
  after(:each) do
    container.kill
    container.delete(:force => true)
  end

  it 'installs the right version of Linux' do
    expect(os_version).to include('3.4.3')
  end

  context 'installs required os packages' do
    APK_PKGS.each do |pkg|
      it "#{pkg}" do
        expect(apk_pkg(pkg)).to eq 0
      end
    end
  end

  it "installs the openstackclient package" do
    expect(pypi_pkg('python-openstackclient')).to include('OpenStack Command-line Client')
  end

  context 'declares environment variables in the container' do
    ENV_VARS.each_key do |var|
      it "declares the #{var} variable" do
        expect(@envs[var]).to include(ENV_VARS[var])
      end
    end
  end

  describe file '/opt/openstackcli/openstack' do
    it { should be_file }
    its(:content) { should match Regexp.escape('OS_CMD="openstack ${@') }
  end

  it 'should have CMD /bin/sh' do
    expect(image.json["Config"]["Cmd"]).to include("/bin/sh")
  end

  describe file '/opt/Dockerfile' do
    it { should be_file }
    its(:content) { should match File.read('mk2/Dockerfile') }
  end

  describe file '/opt/README.md' do
    it { should be_file }
    its(:content) { should match File.read('mk2/README.md') }
  end
end
