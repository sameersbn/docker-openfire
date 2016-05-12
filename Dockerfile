FROM sameersbn/ubuntu:14.04.20160504
MAINTAINER sameer@damagehead.com

ENV OPENFIRE_VERSION=4.0.2 \
    OPENFIRE_USER=openfire \
    OPENFIRE_DATA_DIR=/var/lib/openfire \
    OPENFIRE_LOG_DIR=/var/log/openfire

RUN apt-get update \
 && apt-get install -y software-properties-common python-software-properties \
 && add-apt-repository ppa:openjdk-r/ppa \
 && apt-get update \
 && apt-get install -y openjdk-8-jre openjdk-7-jre \
 && update-java-alternatives --jre-headless -s java-1.8.0-openjdk-amd64 \
 && wget "http://download.igniterealtime.org/openfire/openfire_${OPENFIRE_VERSION}_all.deb" -O /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && dpkg -i /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && mv /var/lib/openfire/plugins/admin /usr/share/openfire/plugin-admin \
 && rm -rf openfire_${OPENFIRE_VERSION}_all.deb \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3478/tcp 3479/tcp 5222/tcp 5223/tcp 5229/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp
VOLUME ["${OPENFIRE_DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
