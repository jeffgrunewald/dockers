FROM ubuntu:xenial-20170710

ARG docker_version=17.06.0
ARG gosu_version=1.10
ARG smellbaron_version=0.4.2
ARG user=woodhouse
ARG uid=1000

RUN apt-get -qq update \
 && apt-get install -yqq \
      curl \
      git \
      openjdk-8-jdk \
      openssh-server \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/run/sshd \
 && smellbaron_bin=https://github.com/ohjames/smell-baron/releases/download/v${smellbaron_version}/smell-baron \
 && gosu_bin=https://github.com/tianon/gosu/releases/download/${gosu_version}/gosu-amd64 \
 && curl -fsSL "${smellbaron_bin}" -o /bin/smell-baron \
 && curl -fsSL "${gosu_bin}" -o /usr/local/bin/gosu \
 && chmod a+x /bin/smell-baron /usr/local/bin/gosu

RUN groupadd --gid ${uid} --system ${user} \
 && useradd --create-home --gid ${uid} --system --uid ${uid} --shell /bin/bash ${user}

RUN curl -L "https://download.docker.com/linux/static/stable/x86_64/docker-${docker_version}-ce.tgz" \
      | tar xzf - --strip-components=1 -C '/usr/local/bin' docker/docker

EXPOSE 22

COPY set-auth-key /
COPY Dockerfile /opt/Dockerfile-woodhouse-agent
COPY README.md /opt/README-woodhouse-agent.md

ENTRYPOINT ["/bin/smell-baron", "-c", "/set-auth-key", "---"]
CMD ["/usr/sbin/sshd", "-D"]

LABEL docker_version=${docker_version} \
      gitrepo="https://github.com/jeffgrunewald/dockers" \
      maintainer="Jeff Grunewald <jeff@grunewalddesign.com>" \
      gosu_version=${gosu_version} \
      smellbaron_version=${smellbaron_version}
