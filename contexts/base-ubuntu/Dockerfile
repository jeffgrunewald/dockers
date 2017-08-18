FROM ubuntu:16.04

ARG cache_date=2017-04-08

ARG confd_version=0.12.0
ARG gosu_version=1.10
ARG smellbaron_version=0.4.2

ARG user_name=phillipfry
ARG user_id=999

ARG timezone=America/New_York

ENV TERM=xterm

RUN apt-get -qq update \
 && apt-get -yqq install \
      curl \
      dnsutils \
      iputils-ping \
      less \
      strace \
      telnet \
      vim \
 && apt-get -yqq clean \
 && rm -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/*

RUN scm=https://github.com \
 && curl -sL "${scm}/kelseyhightower/confd/releases/download/v${confd_version}/confd-${confd_version}-linux-amd64" -o /usr/local/bin/confd \
 && curl -sL "${scm}/ohjames/smell-baron/releases/download/v${smellbaron_version}/smell-baron" -o /bin/smell-baron \
 && curl -sL "${scm}/tianon/gosu/releases/download/${gosu_version}/gosu-amd64" -o /usr/local/bin/gosu \
 && chmod a+x /usr/local/bin/confd /bin/smell-baron /usr/local/bin/gosu

RUN echo "${timezone}" > /etc/timezone \
 && rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

RUN groupadd --gid ${user_id} --system ${user_name} \
 && useradd --gid ${user_name} --system --uid ${user_id} ${user_name}

COPY Dockerfile /opt/Dockerfile-base-ubuntu
COPY README.md /opt/README-base-ubuntu.md

ENTRYPOINT ["/bin/smell-baron"]

LABEL maintainer=jeff@grunewalddesign.com \
      os_version=ubuntu:16.04 \
      cache_date=${cache_date} \
      confd_version=${confd_version} \
      gosu_version=${gosu_version} \
      smellbaron_version=${smellbaron_version} \
      user_name=${user_name} \
      user_id=${user_id} \
      timezone=${timezone}
