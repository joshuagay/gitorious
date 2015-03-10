FROM ubuntu:14.04
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install memcached

ENTRYPOINT ["/usr/bin/memcached"]
CMD ["-m", "64"]
USER memcache

EXPOSE 11211
