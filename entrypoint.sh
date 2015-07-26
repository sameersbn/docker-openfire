#!/bin/bash
set -e

# create openfire data dir
mkdir -p ${OPENFIRE_DATA_DIR}/openfire
chmod -R 0755 ${OPENFIRE_DATA_DIR}/openfire
chown -R ${OPENFIRE_USER}:${OPENFIRE_USER} ${OPENFIRE_DATA_DIR}/openfire

# create openfire log dir
mkdir -p ${OPENFIRE_LOG_DIR}
chmod -R 0755 ${OPENFIRE_LOG_DIR}
chown -R ${OPENFIRE_USER}:${OPENFIRE_USER} ${OPENFIRE_LOG_DIR}

# populate default openfire configuration if it does not exist
if [ ! -d ${OPENFIRE_DATA_DIR}/openfire/etc ]; then
  mv /etc/openfire ${OPENFIRE_DATA_DIR}/openfire/etc
fi
rm -rf /etc/openfire
ln -sf ${OPENFIRE_DATA_DIR}/openfire/etc /etc/openfire

if [ ! -d ${OPENFIRE_DATA_DIR}/openfire/lib ]; then
  mv /var/lib/openfire ${OPENFIRE_DATA_DIR}/openfire/lib
fi
rm -rf /var/lib/openfire
ln -sf ${OPENFIRE_DATA_DIR}/openfire/lib /var/lib/openfire

# allow arguments to be passed to openfire launch
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
fi

# default behaviour is to launch openfire
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid ${OPENFIRE_USER}:${OPENFIRE_USER} --exec /usr/bin/java -- \
    -server \
    -DopenfireHome=/usr/share/openfire \
    -Dopenfire.lib.dir=/usr/share/openfire/lib \
    -classpath /usr/share/openfire/lib/startup.jar \
    -jar /usr/share/openfire/lib/startup.jar ${EXTRA_ARGS}
else
  exec "$@"
fi


