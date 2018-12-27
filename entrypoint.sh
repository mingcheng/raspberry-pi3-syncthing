#!/bin/bash

if ! getent passwd ${SYNCTHING_USERID}; then
    echo "Creating new syncthing account with user ID ${SYNCTHING_USERID}"
    addgroup -g ${SYNCTHING_GROUPID} syncthing
    adduser -H -S -G syncthing -g "Syncthing Account" -u ${SYNCTHING_USERID} syncthing
fi

if [[ $(stat -c %U /config) != syncthing ]]; then
    echo "/Config volume has incorrect ownership, fixing"
    chown -R syncthing:syncthing /config
fi

if [[ $(stat -c %U /syncthing) != syncthing ]]; then
    echo "/syncthing volume has incorrect ownership, fixing"
    chown -R syncthing:syncthing /syncthing
fi

if [[ ! -f /config/config.xml ]]; then
    echo "Config is not found, generating"
    /bin/gosu ${SYNCTHING_USERID} /bin/syncthing -generate="/config"
fi

exec /bin/gosu ${SYNCTHING_USERID} /bin/syncthing -home "/config" -gui-address "0.0.0.0:8384" -no-browser $@