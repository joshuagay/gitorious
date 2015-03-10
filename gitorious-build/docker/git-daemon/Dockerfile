FROM ubuntu:14.04
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install git-daemon-sysvinit
RUN useradd -m -d /home/git -u 5000 -U git

ADD run /usr/local/bin/run

EXPOSE 9418

CMD ["/usr/local/bin/run"]
