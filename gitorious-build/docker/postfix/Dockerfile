FROM ubuntu:14.04
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install postfix
RUN postconf -e mynetworks="0.0.0.0/0"

ADD run /usr/local/bin/run

EXPOSE 25

CMD ["/usr/local/bin/run"]
