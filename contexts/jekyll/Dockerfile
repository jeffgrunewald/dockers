FROM jeffgrunewald/base-alpine:20170711-0011

ARG cache_date=2017-07-15
ARG jekyll_version=3.4.3

RUN apk update \
 && apk add --no-cache \
      build-base \
      libffi-dev \
      nodejs \
      ruby \
      ruby-dev \
      zlib-dev

RUN gem install --no-rdoc --no-ri \
      jekyll:${jekyll_version} \
      jekyll-feed \
      jekyll-gist \
      jekyll-paginate \
      jekyll-sitemap \
      jemoji \
      json \
      rb-pygments \
      redcarpet

VOLUME ["/data/", "/usr/share/nginx/html"]

WORKDIR /data

COPY Dockerfile /opt/Dockerfile-jekyll
COPY README.md /opt/README-jekyll.md
CMD ["jekyll", "build", "--watch", "--destination=/usr/share/nginx/html"]

LABEL cache_date=${cache_date} \
      maintainer=jeff@grunewalddesign.com \
      jekyll_version=${jekyll_version}
