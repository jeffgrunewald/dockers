FROM jeffgrunewald/base-alpine:20170711-0011

ARG cache_date=2017-07-10

ARG composiler_version=0.1.1
ARG docker_compose_version=1.14.0

ENV DOCKER_HOST="" \
    ENVIRONMENT="" \
    EXEC=true \
    MODE=standalone \
    OUTFILE=docker-compose.yml \
    STACK_NAME=stack \
    TEMPLATES="" \    
    VERSION=3.3

RUN apk --update add -q \
           docker \
           py2-pip==9.0.1-r1 \
 && scm=https://github.com \
 && curl -L "${scm}/jeffgrunewald/composiler/releases/download/v${composiler_version}/composiler-${composiler_version}-linux-amd64" \
            > /usr/local/bin/composiler \
 && pip install docker-compose==${docker_compose_version} \
 && apk del -q \
           py-pip

VOLUME /composiler/output /var/run/docker.sock

COPY run-composiler /composiler/

RUN chmod a+x /usr/local/bin/composiler /composiler/run-composiler

COPY Dockerfile /opt/Dockerfile-composiler
COPY README.md /opt/README-composiler.md

CMD ["gosu", "phillipfry", "/composiler/run-composiler"]

LABEL composiler_version=${composiler_version} \
      docker_compose_version=${docker_compose_version} \
      maintainer=jeff@grunewalddesign.com
