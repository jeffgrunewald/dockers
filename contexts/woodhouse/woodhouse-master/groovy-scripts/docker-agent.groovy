instance = jenkins.model.Jenkins.getInstance()
jenkins_home = System.getenv('JENKINS_HOME')
jenkins_agent_image = System.getenv('JENKINS_AGENT_IMAGE')
jenkins_agent_home = System.getenv('JENKINS_AGENT_HOME')
jenkins_agent_username = System.getenv('JENKINS_AGENT_USERNAME')
jenkins_agent_ssh_credential_id = System.getenv('JENKINS_AGENT_SSH_CREDENTIAL_ID')
jenkins_agent_labels = System.getenv('JENKINS_AGENT_LABELS')
jenkins_agent_start_prefix = System.getenv('JENKINS_AGENT_START_PREFIX')

privateKeyFilename = "${jenkins_home}/.ssh/agent_id_rsa"
environmentsString = """AUTHORIZED_KEYS=${new File("${privateKeyFilename}.pub").text}"""

credentials = new com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey(
  com.cloudbees.plugins.credentials.CredentialsScope.GLOBAL,
  jenkins_agent_ssh_credential_id, /* String id */
  jenkins_agent_username, /* String username */
  new com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource(privateKeyFilename), /* PrivateKeySource privateKeySource */
  '', /* String passphrase */
  'SSH key for docker agent'/* String description */
)
domain = com.cloudbees.plugins.credentials.domains.Domain.global()
store = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
store.addCredentials(domain, credentials)
volumesString = """/var/run/docker.sock:/var/run/docker.sock
${jenkins_agent_home}:${jenkins_agent_home}"""

// Find the jenkins_agent_ssh_credential
// Allows newly created credential to be overridden with existing credential
allCredentials = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
                 com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
                 jenkins.model.Jenkins.instance
                 )
dockerCredential = allCredentials.findResult { it.id == jenkins_agent_ssh_credential_id ? it : null }

dockerTemplateBase = new com.nirima.jenkins.plugins.docker.DockerTemplateBase(
  jenkins_agent_image, /* String image */
  '', /* String dnsString */
  '', /* String network */
  '', /* String dockerCommand */
  volumesString, /* String volumesString */
  '', /* String volumesFromString */
  environmentsString, /* String environmentsString */
  '', /* String lxcConfString */
  '', /* String hostname */
  null, /* Integer memoryLimit */
  null, /* Integer memorySwap */
  null, /* Integer cpuShares */
  '', /* String bindPorts */
  true, /* boolean bindAllPorts */
  false, /* boolean privileged */
  false, /* boolean tty */
  '' /* String macAddress */
)
dockerTemplate = new com.nirima.jenkins.plugins.docker.DockerTemplate(
  dockerTemplateBase,
  jenkins_agent_labels, /* String labelString */
  jenkins_agent_home, /* String remoteFs */
  jenkins_agent_home, /* String remoteFsMapping */
  '' /* String instanceCapSt */
)
dockerTemplate.mode = hudson.model.Node.Mode.EXCLUSIVE
dockerTemplate.retentionStrategy = new hudson.slaves.RetentionStrategy.Always()
sshConnector = new hudson.plugins.sshslaves.SSHConnector (
  22, /* int port */
  dockerCredential, /* StandardUsernameCredentials credentials */
  '', /* String jvmOptions */
  '', /* String javaPath */
  jenkins_agent_start_prefix, /* String prefixStartSlaveCmd */
  '' /* String suffixStartSlaveCmd */
)
sshLauncher = new com.nirima.jenkins.plugins.docker.launcher.DockerComputerSSHLauncher(sshConnector)
dockerTemplate.setLauncher(sshLauncher)
dockerCloud = new com.nirima.jenkins.plugins.docker.DockerCloud(
  'docker-agent', /* String name */
  [dockerTemplate], /* List<? extends DockerTemplate> templates */
  'unix:///var/run/docker.sock', /* String serverUrl */
  100, /* int containerCap */
  0, /* int connectTimeout */
  0, /* int readTimeout */
  '', /* String credentialsId */
  '' /* String version */
)
instance.clouds.replaceBy([dockerCloud])
instance.save()
