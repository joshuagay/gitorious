FROM ubuntu:14.04
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

ENV RAILS_ENV production

# add git user
RUN useradd -m -d /home/git -u 5000 -U git

# install required packages
RUN apt-get -y install git build-essential rsync libmysqlclient-dev \
  libxml2-dev libxslt1-dev libreadline6 libicu-dev imagemagick nodejs sudo \
  mysql-client

# install Ruby 2.0 and make it a default Ruby
RUN apt-get install -y ruby2.0 ruby2.0-dev
RUN rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/erb && \
  ln -s /usr/bin/ruby2.0 /usr/bin/ruby && \
  ln -s /usr/bin/gem2.0 /usr/bin/gem && \
  ln -s /usr/bin/irb2.0 /usr/bin/irb && \
  ln -s /usr/bin/erb2.0 /usr/bin/erb && \
  gem update --system && gem pristine --all

# create dir for the app and docker's files
RUN mkdir /srv/gitorious && chown git:git /srv/gitorious

# clone app repository into /srv/gitorious/app
RUN su git -c "git clone git://gitorious.org/gitorious/mainline.git /srv/gitorious/app"

WORKDIR /srv/gitorious/app

# checkout specific commit
RUN su git -c "git fetch && git checkout -b deploy b97c197"

# install bundler
RUN gem install bundler --no-rdoc --no-ri

# install tools required for compiling rugged gem's native exts
RUN apt-get -y install cmake pkg-config

# checkout source code and bundle
RUN su git -c "bundle install --deployment --without postgres"

# build assets
RUN su git -c "git submodule update --recursive --init && bundle exec rake assets:precompile"

# put revision (git sha) and version (tag + sha) into public/
RUN su git -c "git rev-parse HEAD >public/REVISION && git describe --tags HEAD >public/VERSION"

# symlink uploads
RUN ln -ns /srv/gitorious/data/uploads /srv/gitorious/app/public/system && chown -h git:git /srv/gitorious/app/public/system

# copy internal configs into the image
ADD config /srv/gitorious/app/config/internal

ADD copy-configs /usr/local/bin/copy-configs
ADD create-repositories-dir /usr/local/bin/create-repositories-dir
ADD fix-ownerships /usr/local/bin/fix-ownerships
ADD run /usr/local/bin/run

EXPOSE 3000
VOLUME ["/srv/gitorious/app/log"]
VOLUME ["/srv/gitorious/config"]

ENTRYPOINT ["/usr/local/bin/run"]
