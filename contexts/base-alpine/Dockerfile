FROM alpine:3.6

ARG cache_date=2017-07-10

ARG confd_version=0.11.0
ARG gosu_version=1.10
ARG smellbaron_version=0.4.2

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
 && curl -sL "${scm}/ohjames/smell-baron/releases/download/v${smellbaron_version}/smell-baron.musl" -o /bin/smell-baron \
 && curl -sL "${scm}/tianon/gosu/releases/download/${gosu_version}/gosu-amd64" -o /usr/local/bin/gosu \
 && chmod a+x /usr/local/bin/confd /bin/smell-baron /usr/local/bin/gosu

RUN delgroup ping && addgroup -g ${user_id} -S ${user_name} \
 && adduser -G ${user_name} -S -u ${user_id} ${user_name}

COPY Dockerfile /opt/Dockerfile-base-alpine
COPY README.md /opt/README-base-alpine.md

ENTRYPOINT ["/bin/smell-baron"]

LABEL maintainer=jeff@grunewalddesign.com \
      os_version=alpine:3.6 \
      cache_date=${cache_date} \
      confd_version=${confd_version} \
      gosu_version=${gosu_version} \
      smellbaron_version=${smellbaron_version} \
      user_name=${user_name} \
      user_id=${user_id} \
      timezone=${timezone}
