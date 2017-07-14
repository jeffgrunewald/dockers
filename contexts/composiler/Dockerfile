FROM jeffgrunewald/base-alpine:20170711-0011

ARG cache_date=2017-07-10

ARG composiler_version=0.2.1
ARG docker_compose_version=1.14.0

ENV DOCKER_HOST="unix:///var/run/docker.sock" \
    ENVIRONMENT="" \
    ENV_LIST="" \
    EXEC=true \
    MODE=standalone \
    OUTFILE=docker-compose.yml \
    STACK_NAME=stack \
    TEMPLATES="" \
    VERSION=3.3

RUN apk --update add -q \
           docker==17.05.0-r0 \
           py2-pip==9.0.1-r1 \
 && scm=https://github.com \
    repo=jeffgrunewald/composiler/releases/download \
 && curl -L "${scm}/${repo}/v${composiler_version}/composiler-${composiler_version}-linux-amd64" \
            > /usr/local/bin/composiler \
 && pip install docker-compose==${docker_compose_version} \
 && apk del -q \
           py-pip

VOLUME /composiler/output /var/run/docker.sock

COPY build-envfile run-composiler /composiler/

RUN chmod a+x /usr/local/bin/composiler \
              /composiler/build-envfile \
              /composiler/run-composiler

COPY Dockerfile /opt/Dockerfile-composiler
COPY README.md /opt/README-composiler.md

WORKDIR /composiler
CMD ["gosu", "phillipfry", "./build-envfile", "---", "gosu", "phillipfry", "./run-composiler"]

LABEL composiler_version=${composiler_version} \
      docker_compose_version=${docker_compose_version} \
      maintainer=jeff@grunewalddesign.com
