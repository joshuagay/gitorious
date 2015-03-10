FROM gitorious/app
MAINTAINER Marcin Kulik

RUN apt-get -y install sphinxsearch

ADD run-sphinx /usr/local/bin/run-sphinx

EXPOSE 9306
EXPOSE 9312

CMD ["/usr/local/bin/run"]
