#!/bin/bash
set -e

chmod 775 /data

mkdir -p /data/openfire
chown -R openfire:openfire /data/openfire

# populate default openfire configuration if it does not exist
if [ ! -d /data/openfire/etc ]; then
  mv /etc/openfire /data/openfire/etc
fi
rm -rf /etc/openfire
ln -sf /data/openfire/etc /etc/openfire

if [ ! -d /data/openfire/lib ]; then
  mv /var/lib/openfire /data/openfire/lib
fi
rm -rf /var/lib/openfire
ln -sf /data/openfire/lib /var/lib/openfire

# default behaviour is to launch openfire
if [[ -z ${1} ]]; then
  echo "Starting openfire..."
  exec start-stop-daemon --start --chuid openfire:openfire --exec /usr/bin/java -- \
    -server \
    -DopenfireHome=/usr/share/openfire \
    -Dopenfire.lib.dir=/usr/share/openfire/lib \
    -classpath /usr/share/openfire/lib/startup.jar \
    -jar /usr/share/openfire/lib/startup.jar
else
  exec "$@"
fi


