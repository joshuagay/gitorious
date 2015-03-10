FROM gitorious/app
MAINTAINER Marcin Kulik

RUN apt-get -y install nginx

ADD nginx.conf /etc/nginx/nginx.conf
ADD gitorious.conf.erb /etc/nginx/sites-available/default.erb
ADD run /usr/local/bin/run

EXPOSE 80
VOLUME ["/var/log/nginx"]

CMD ["/usr/sbin/nginx"]
