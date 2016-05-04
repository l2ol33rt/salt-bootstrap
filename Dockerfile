FROM debian:jessie
MAINTAINER "SaltStack Team"

# Bootstrap script options: install Salt Master by default
ENV BOOTSTRAP_OPTS='-M -A 127.0.0.1'
# Version of salt to install: stable or git
ENV SALT_VERSION='git 2015.8'

COPY bootstrap-salt.sh /tmp/

# Prevent udev from being upgraded inside the container, dpkg will fail to configure it
RUN echo udev hold | dpkg --set-selections
# Upgrade System and Install Salt
RUN sh /tmp/bootstrap-salt.sh -U -X -d $BOOTSTRAP_OPTS $SALT_VERSION && \
    apt-get clean
RUN /usr/sbin/update-rc.d -f ondemand remove; \
    update-rc.d salt-minion defaults && \
    update-rc.d salt-master defaults || true

EXPOSE 4505 4506
