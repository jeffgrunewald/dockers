FROM alpine:3.6

ARG cache_date=2017-10-03

ARG confd_version=0.13.0
ARG gosu_version=1.10
ARG tini_version=0.16.1

ARG user_name=phillipfry
ARG user_id=999

ARG timezone=America/New_York

ENV TERM=xterm

RUN apk add --no-cache --virtual .build-deps tzdata \
 && cp /usr/share/zoneinfo/${timezone} /etc/localtime \
 && apk del .build-deps

RUN apk add --no-cache \
      ca-certificates \
      curl \
      git \
      iputils

RUN scm=https://github.com \
 && curl -sL "${scm}/kelseyhightower/confd/releases/download/v${confd_version}/confd-${confd_version}-linux-amd64" -o /usr/local/bin/confd \
 && curl -sL "${scm}/krallin/tini/releases/download/v${tini_version}/tini-static-muslc-amd64" -o /sbin/tini \
 && curl -sL "${scm}/tianon/gosu/releases/download/${gosu_version}/gosu-amd64" -o /usr/local/bin/gosu \
 && chmod a+x /usr/local/bin/confd /sbin/tini /usr/local/bin/gosu

RUN delgroup ping && addgroup -g ${user_id} -S ${user_name} \
 && adduser -G ${user_name} -S -u ${user_id} ${user_name}

COPY Dockerfile /opt/Dockerfile-base-alpine
COPY README.md /opt/README-base-alpine.md

ENTRYPOINT ["/sbin/tini", "--"]

LABEL maintainer=jeff@grunewalddesign.com \
      os_version=alpine:3.6 \
      cache_date=${cache_date} \
      confd_version=${confd_version} \
      gosu_version=${gosu_version} \
      tini_version=${tini_version} \
      user_name=${user_name} \
      user_id=${user_id} \
      timezone=${timezone}
