FROM sameersbn/ubuntu:12.04.20140519
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
		apt-get install -y openjdk-7-jre && \
		apt-get clean # 20140519

ADD assets/ /app/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD authorized_keys /root/.ssh/

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

VOLUME ["/app/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
