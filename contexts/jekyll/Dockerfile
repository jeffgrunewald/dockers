FROM jeffgrunewald/base-ubuntu:16.04-1
MAINTAINER Jeff Grunewald <jeff@grunewalddesign.com>

ARG update_on=2017-04-08

RUN apt-get -qq update \
 && apt-get -yqq install \
      ruby \
      ruby-dev \
      build-essential \
      nodejs \
      zlib1g-dev

RUN gem install --no-rdoc --no-ri \
      jekyll:3.4.3 \
      jekyll-feed \
      jekyll-gist \
      jekyll-paginate \
      jekyll-sitemap \
      jemoji \
      rb-pygments \
      redcarpet

VOLUME ["/data/", "/var/www/html/"]

WORKDIR /data

CMD ["jekyll", "build", "--watch", "--destination=/var/www/html"]
