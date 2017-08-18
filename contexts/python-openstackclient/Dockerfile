FROM alpine:3.4

ARG client_version

ENV CINDER_ENDPOINT_TYPE=publicURL \
    LC_ALL=C \
    NOVA_ENDPOINT_TYPE=publicURL \
    OS_AUTH_URL=http://172.16.0.1:5000/v3 \
    OS_AUTH_VERSION=3 \
    OS_CMD='openstack server list' \
    OS_ENDPOINT_TYPE=publicURL \
    OS_IDENTITY_API_VERSION=3 \
    OS_NO_CACHE=1 \
    OS_PASSWORD=password \
    OS_PROJECT_DOMAIN_NAME=Default \
    OS_PROJECT_NAME=tenant \
    OS_TENANT_NAME=${OS_PROJECT_NAME} \
    OS_REGION_NAME=RegionOne \
    OS_USER_DOMAIN_NAME=Default \
    OS_USERNAME=userId

RUN apk add --no-cache --update \
      ca-certificates \
      gcc \
      linux-headers \
      musl-dev \
      python-dev \
      py-pip \
      py-setuptools \
    && pip install --upgrade --no-cache-dir \
      python-openstackclient==${client_version} \
    && apk del gcc linux-headers musl-dev

RUN mkdir -p /opt/openstackcli

COPY openstack /opt/openstackcli/openstack

CMD [ "/bin/sh" ]

COPY Dockerfile /opt/Dockerfile-openstackcli
COPY README.md /opt/README-openstackcli.md

LABEL maintainer=jeff@grunewalddesign.com \
      openstackclient_version=${client_version}
