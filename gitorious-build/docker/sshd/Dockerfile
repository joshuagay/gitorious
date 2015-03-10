FROM gitorious/app
MAINTAINER Marcin Kulik

RUN apt-get -y install openssh-server

RUN mkdir /var/run/sshd

# add empty authorized_keys file for git user
RUN mkdir -p /home/git/.ssh && chown -R git:git /home/git/.ssh && chmod 0700 /home/git/.ssh

# setup /usr/bin/gitorious so it executes bin/gitorious from the app dir
RUN ln -s /srv/gitorious/app/bin/gitorious /usr/bin/gitorious
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

ADD custom-hooks/custom-pre-receive /srv/gitorious/app/data/hooks/custom-pre-receive
ADD custom-hooks/custom-update /srv/gitorious/app/data/hooks/custom-update
ADD custom-hooks/custom-post-receive /srv/gitorious/app/data/hooks/custom-post-receive
RUN chown -R git:git /srv/gitorious/app/data/hooks

ADD run /usr/local/bin/run

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
