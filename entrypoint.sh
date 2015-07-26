#!/bin/bash
set -e

chmod 775 /data

mkdir -p /data/openfire
chown -R ${OPENFIRE_USER}:${OPENFIRE_USER} /data/openfire

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

# allow arguments to be passed to openfire launch
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
fi

# default behaviour is to launch openfire
if [[ -z ${1} ]]; then
  echo "Starting openfire..."
  exec start-stop-daemon --start --chuid ${OPENFIRE_USER}:${OPENFIRE_USER} --exec /usr/bin/java -- \
    -server \
    -DopenfireHome=/usr/share/openfire \
    -Dopenfire.lib.dir=/usr/share/openfire/lib \
    -classpath /usr/share/openfire/lib/startup.jar \
    -jar /usr/share/openfire/lib/startup.jar ${EXTRA_ARGS}
else
  exec "$@"
fi


