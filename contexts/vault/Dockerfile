FROM jeffgrunewald/base-ubuntu:20171003-2324

ARG vault_version=0.8.3

ENV CONFD_BACKEND=env \
    CONSUL_ADDRESS=consul \
    DOMAIN=example.com \
    LDAP_SERVER=ldap.example.com \
    VAULT_CONFIG_DIR=/vault/config \
    VAULT_INTERFACE=eth0 \
    VAULT_REDIRECT_INTERFACE=eth0 \
    VAULT_CLUSTER_INTERFACE=eth0

RUN apt-get update -qq \
 && apt-get install -yqq ca-certificates \
    gnupg \
    jq \
    libcap-dev \
    openssl \
    supervisor \
    unzip \
 && vault_zip=vault_${vault_version}_linux_amd64.zip \
 && curl -sLO https://releases.hashicorp.com/vault/${vault_version}/${vault_zip} \
 && unzip -d /bin ${vault_zip} \
 && apt-get -qq clean \
 && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

RUN mkdir -p /vault/config \
 && mkdir /vault/file \
 && mkdir /vault/logs \
 && mkdir /vault/policies \
 && mkdir -p /var/log/supervisor \
 && chown -R phillipfry:phillipfry /vault

COPY confd /etc/confd
COPY admin.hcl /vault/policies/
COPY run-vault.sh \
     init-vault.sh \
     /vault/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod a+x /vault/run-vault.sh /vault/init-vault.sh

VOLUME /vault/logs \
       /vault/file

EXPOSE 8200

COPY Dockerfile /opt/Dockerfile-vault
COPY README.md /opt/README-vault.md

CMD ["/usr/bin/supervisord"]

LABEL vault_version=${vault_version} \
      maintainer=jeff@grunewalddesign.com