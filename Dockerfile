FROM ubuntu:18.04
MAINTAINER Dimitrios Desyllas <pcmagas@disroot.org>

ENV OPENFIRE_USER=openfire\
    OPENFIRE_DATA_DIR=/var/lib/openfire\
    OPENFIRE_LOG_DIR=/var/log/openfire

ARG OPENFIRE_VERSION=4.2.3

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl openjdk-8-jre sudo \
 && curl -L "https://github.com/igniterealtime/Openfire/releases/download/v${OPENFIRE_VERSION}/openfire_${OPENFIRE_VERSION}_all.deb" -o /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && dpkg -i /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && mv /var/lib/openfire/plugins/admin /usr/share/openfire/plugin-admin \
 && DEBIAN_FRONTEND=noninteractive apt-get purge -y curl \
 && rm -rf openfire_${OPENFIRE_VERSION}_all.deb \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3478/tcp 3479/tcp 5222/tcp 5223/tcp 5229/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp
VOLUME ["${OPENFIRE_DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
