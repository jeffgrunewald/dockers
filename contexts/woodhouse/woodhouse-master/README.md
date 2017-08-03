# woodhouse jenkins 2 docker

The Woodhouse Docker Repository

## Project Vision

PURPOSE:
To create a quickly deployable Jenkins CI system in a Docker container, pre-configured with desired plugins
and bootstrapping a Job DSL plugin 'seed job' to follow and poll a remote repository and construct derivative
jobs, written in the Jenkins Groovy DSL language, from the scripts stored therein.

USAGE:
  * docker run -d --name woodhouse -p 8080:8080 -p 50000:50000 -e SEEDREPO_GIT=https://github.com/some-project-name.git
    -e JENKINS_URL=http://grunewalddesign.com:8080 jeffgrunewald/woodhouse:2.60.2
  * docker-compose -f compose-woodhouse.yml up -d

DETAILS:
After initial, standard configuration of the container in earlier build steps, the Bash script 'install-plugins.sh' takes a
string of space-separated Jenkins plugin names (optionally with explicit version numbers appended with :) as input and installs
them, including any unspecified dependencies. At startup, the Jenkins server initializes Jenkins, feeding any JENKINS_OPTS and/or
JAVA_OPTS to the 'java -jar jenkins.war' command. During initialization, configs, themes, and plugins are copied from /usr/share/jenkins to the Jenkins home and any scripts in the init.groovy.d directory are executed. In this case, Groovy scripts
configure the basic UI URL and locally served Material Theme URL, add the default administrator account (this account should not
use the default credentials in a production environment and as all credentials must be passed into the container as ENVARS to be
processed, should be changed shortly after container initialization in a production setting), re-enable the master-to-slave
security configuration (activated at first restart) configure the slave agent TCP port set in the container image build, and
bootstrap a Job DSL 'seed job' to clone the contents of a remote git/svn repository of other Groovy-DSL-defined Jenkins job scripts,
construct jobs based on them, and begin executing them according to their configuration.

ARGS/ENVARS:
  * JENKINS_VERSION - Defaults to 2.60.2 LTS
  * JENKINS_URL - Jenkins war file online repo; defaults to repo.jenkins-ci.org download
  * user - Account Jenkins will run as; defaults to 'jenkins'
  * uid - User id assigned to Jenkins account to control file permissions on volumes; defaults to 1000
  * LOCAL_ADMIN - User account for initial Jenkins administration; defaults to 'archer' - FOR SETUP ONLY
  * LOCAL_PASSWORD - Password for initial Jenkins administrator account; defaults to 'sterling' - FOR SETUP ONLY
  * JAVA_OPTS - Set JVM options; default '-Djenkins.install.runSetupWizard=false' to disable initial config wizard
  * JENKINS_HOME - Location of Jenkins working installation, defaults to '/var/lib/jenkins'
  * JENKINS_SLAVE_AGENT_PORT - TCP port used to communicate between Jenkins master and slave nodes; defaults to 50000
  * JENKINS_UC - Jenkins update center; defaults to updates.jenkins.io
  * COPY_REFERENCE_FILE_LOG - Defaults to root of JENKINS_HOME

PORTS:
  * 8080 - Default administration UI TCP port
  * 50000 - Default master-agent node communication port

VOLUMES:
  * /data/jenkins
