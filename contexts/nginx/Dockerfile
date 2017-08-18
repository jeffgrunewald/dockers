FROM jeffgrunewald/base-alpine:20170711-0011

ARG cache_data=2017-07-15
ARG nginx_version=1.12.1-r0

RUN apk add --update \
      nginx=${nginx_version} \
 && rm -rf /var/cache/apk/*

RUN mkdir /run/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY Dockerfile /opt/Dockerfile-nginx
COPY README.md /opt/README-nginx.md

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

LABEL cache_date=${cache_date} \
      maintainer=jeff@grunewalddesign.com \
      nginx_version=${nginx_version}