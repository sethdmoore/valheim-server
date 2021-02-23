#!/bin/sh

main() {
  if [ -z "$APP_ID" ]; then
    echo 'WARNING: APP_ID is unset!' 1>&2
    echo '         Assuming you mean "896660" for Valheim' 1>&2
    APP_ID="896660"
  fi

  if [ -z "$INSTALL_DIR" ]; then
    echo 'WARNING: INSTALL_DIR is unset!' 1>&2
    echo '         Assuming you want /opt/valheim_server' 1>&2
    INSTALL_DIR="/opt/valheim_server"
  fi

  mkdir -p "$INSTALL_DIR"

  steamcmd +login anonymous \
           +force_install_dir "$INSTALL_DIR" \
           +app_update "$APP_ID" validate \
           +quit
}

main "$@"
