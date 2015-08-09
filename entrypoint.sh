#!/bin/bash
set -e

rewire_openfire() {
  rm -rf /usr/share/openfire/{conf,resources/security,lib/log4j.xml}
  ln -sf ${OPENFIRE_DATA_DIR}/conf /usr/share/openfire/
  ln -sf ${OPENFIRE_DATA_DIR}/conf/security /usr/share/openfire/resources/
  ln -sf ${OPENFIRE_DATA_DIR}/conf/log4j.xml /usr/share/openfire/lib/
}

initialize_data_dir() {
  echo "Initializing ${OPENFIRE_DATA_DIR}..."

  mkdir -p ${OPENFIRE_DATA_DIR}
  chmod -R 0750 ${OPENFIRE_DATA_DIR}
  chown -R ${OPENFIRE_USER}:${OPENFIRE_USER} ${OPENFIRE_DATA_DIR}

  # migrates data volume directory structure
  if [[ -d ${OPENFIRE_DATA_DIR}/openfire ]]; then
    echo "Migrating existing data..."
    mv ${OPENFIRE_DATA_DIR}/openfire/etc ${OPENFIRE_DATA_DIR}/conf
    mv ${OPENFIRE_DATA_DIR}/openfire/lib/plugins ${OPENFIRE_DATA_DIR}/plugins
    mv ${OPENFIRE_DATA_DIR}/openfire/lib/embedded-db ${OPENFIRE_DATA_DIR}/embedded-db
    rm -rf ${OPENFIRE_DATA_DIR}/openfire
  fi
  [[ -d ${OPENFIRE_DATA_DIR}/etc ]] && mv ${OPENFIRE_DATA_DIR}/etc ${OPENFIRE_DATA_DIR}/conf
  [[ -d ${OPENFIRE_DATA_DIR}/lib/plugins ]] && mv ${OPENFIRE_DATA_DIR}/lib/plugins ${OPENFIRE_DATA_DIR}/plugins
  [[ -d ${OPENFIRE_DATA_DIR}/lib/embedded-db ]] && mv ${OPENFIRE_DATA_DIR}/lib/embedded-db ${OPENFIRE_DATA_DIR}/embedded-db
  rm -rf ${OPENFIRE_DATA_DIR}/lib

  # initialize the data volume
  if [[ ! -d ${OPENFIRE_DATA_DIR}/conf ]]; then
    sudo -HEu ${OPENFIRE_USER} cp -a /etc/openfire ${OPENFIRE_DATA_DIR}/conf
  fi
  sudo -HEu ${OPENFIRE_USER} mkdir -p ${OPENFIRE_DATA_DIR}/{plugins,embedded-db}
  sudo -HEu ${OPENFIRE_USER} rm -rf ${OPENFIRE_DATA_DIR}/plugins/admin
  sudo -HEu ${OPENFIRE_USER} ln -sf /usr/share/openfire/plugin-admin /var/lib/openfire/plugins/admin

  # create version file
  CURRENT_VERSION=
  [[ -f ${OPENFIRE_DATA_DIR}/VERSION ]] && CURRENT_VERSION=$(cat ${OPENFIRE_DATA_DIR}/VERSION)
  if [[ ${OPENFIRE_VERSION} != ${CURRENT_VERSION} ]]; then
    echo -n "${OPENFIRE_VERSION}" | sudo -HEu ${OPENFIRE_USER} tee ${OPENFIRE_DATA_DIR}/VERSION >/dev/null
  fi
}

initialize_log_dir() {
  echo "Initializing ${OPENFIRE_LOG_DIR}..."
  mkdir -p ${OPENFIRE_LOG_DIR}
  chmod -R 0755 ${OPENFIRE_LOG_DIR}
  chown -R ${OPENFIRE_USER}:${OPENFIRE_USER} ${OPENFIRE_LOG_DIR}
}

# allow arguments to be passed to openfire launch
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
fi

rewire_openfire
initialize_data_dir
initialize_log_dir

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


