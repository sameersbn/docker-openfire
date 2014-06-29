FROM sameersbn/ubuntu:12.04.20140628
MAINTAINER sameer@damagehead.com

ENV OPENFIRE_VERSION 3.9.3
RUN apt-get update && \
		apt-get install -y openjdk-7-jre && \
		wget "http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${OPENFIRE_VERSION}_all.deb" -O /tmp/openfire_${OPENFIRE_VERSION}_all.deb && \
		dpkg -i /tmp/openfire_${OPENFIRE_VERSION}_all.deb && \
		rm -rf openfire_${OPENFIRE_VERSION}_all.deb && \
		apt-get clean # 20140519

ADD init /init

EXPOSE 3478
EXPOSE 3479
EXPOSE 5222
EXPOSE 5223
EXPOSE 5229
EXPOSE 7070
EXPOSE 7443
EXPOSE 7777
EXPOSE 9090
EXPOSE 9091

VOLUME ["/data"]

CMD ["/init"]
