FROM ubuntu:xenial-20170710

ARG jenkins_version=2.60.2
ARG gosu_version=1.10
ARG smellbaron_version=0.4.2

ENV JENKINS_HOME="/data/jenkins" \
    JENKINS_AGENT_HOME="/data/jenkins/agents" \
    JENKINS_AGENT_IMAGE="jeffgrunewald/woodhouse-agent:0.0.1" \
    JENKINS_AGENT_USERNAME="woodhouse" \
    JENKINS_AGENT_SSH_CREDENTIAL_ID="woodhouse-deploy-agent" \
    JENKINS_AGENT_LABELS="docker" \
    JENKINS_AGENT_PORT="50000" \
    JENKINS_AGENT_START_PREFIX="" \
    ENV_INJECT_LOAD_MASTER="false" \
    LOG_LEVEL="INFO" \
    PATH=${JAVA_HOME}/bin:${PATH}

RUN apt-get -qq update \
 && apt-get -qq install -y \
      apt-utils \
      bzip2 \
      curl \
      git \
      net-tools \
      openjdk-8-jdk \
      unzip \
      xz-utils \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG user=woodhouse
ARG uid=1000
ARG LOCAL_ADMIN
ARG LOCAL_PASSWORD

ENV LOCAL_ADMIN=${LOCAL_ADMIN:-archer} \
    LOCAL_PASSWORD=${LOCAL_PASSWORD:-sterling} \
    JENKINS_UC=https://updates.jenkins.io \
    COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

RUN smellbaron_bin=https://github.com/ohjames/smell-baron/releases/download/v${smellbaron_version}/smell-baron \
 && gosu_bin=https://github.com/tianon/gosu/releases/download/${gosu_version}/gosu-amd64 \
 && curl -fsSL "${smellbaron_bin}" -o /bin/smell-baron \
 && curl -fsSL "${gosu_bin}" -o /usr/local/bin/gosu \
 && chmod a+x /bin/smell-baron /usr/local/bin/gosu

RUN groupadd --gid ${uid} --system ${user} \
 && useradd --create-home --gid ${uid} --system --uid ${uid} --shell /bin/bash ${user}

RUN jenkins_war=mirrors.jenkins.io/war-stable/${jenkins_version}/jenkins.war \
 && mkdir -p /usr/share/jenkins \
 && curl -fsSL "${jenkins_war}" -o /usr/share/jenkins/jenkins.war \
 && mkdir -p "${JENKINS_HOME}" \
 && chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins \
 && mkdir -p ${JENKINS_HOME}/userContent \
 && echo "${jenkins_version}" > "${JENKINS_HOME}/jenkins.install.InstallUtil.lastExecVersion" \
 && echo "${jenkins_version}" > "${JENKINS_HOME}/jenkins.install.UpgradeWizard.state"

COPY jenkins-material-theme.css ${JENKINS_HOME}/userContent/
COPY shell-scripts/ /usr/local/bin/
COPY groovy-scripts ${JENKINS_HOME}/init.groovy.d
COPY seeds ${JENKINS_HOME}/seeds
COPY xml-configs/jenkins.CLI.xml ${JENKINS_HOME}/
COPY ssh_config ${JENKINS_HOME}/.ssh/

EXPOSE 8080 \
       ${JENKINS_AGENT_PORT}

VOLUME ${JENKINS_HOME}/jobs \
       ${JENKINS_AGENT_HOME}

WORKDIR ${JENKINS_HOME}

COPY Dockerfile /opt/Dockerfile-woodhouse
COPY README.md /opt/README-woodhouse.md
COPY plugins.txt /opt/

HEALTHCHECK --interval=5m --timeout=5s CMD curl -u ${LOCAL_ADMIN}:${LOCAL_PASSWORD} --fail http://localhost:8080/ || exit 1

RUN /usr/local/bin/install-plugins.sh $(cat /opt/plugins.txt)

ENTRYPOINT [ "/bin/smell-baron" ]
CMD [ "/usr/local/bin/jenkins.sh" ]

LABEL description="Super easy Jenkins 2.0 Installation" \
      gitrepo="https://github.com/jeffgrunewald/dockers" \
      maintainer="Jeff Grunewald <jeff@grunewalddesign.com>" \
      jenkins_user=${user} \
      jenkins_version=${jenkins_version} \
      gosu_version=${gosu_version} \
      smellbaron_version=${smellbaron_version}
