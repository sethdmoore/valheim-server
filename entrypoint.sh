#!/bin/sh

UNKNOWN_VERSION='0000000'
ERROR_VERSION='ERROR'
VERSION_FILE='current_version.txt'
LATEST_VERSION_FILE='latest_version.txt'

update_server() {
  if ! ./scripts/update_valheim.sh; then
    echo "ERROR: updating valheim failed!" 1>&2
    exit 2
  fi
}

compare_versions() {
  # create a dummy current_version.txt if it doesn't exist
  if ! [ -e "$VERSION_FILE" ]; then
    echo "$UNKNOWN_VERSION" > "${INSTALL_DIR}/${VERSION_FILE}"
  fi

  read current_version < "$VERSION_FILE"

  if ! latest_version="$(./scripts/check_update.py)"; then
    echo "WARNING: Couldn't determine latest version." 1>&2
    latest_version="$ERROR_VERSION"
  fi

  # write the latest version to a file
  echo "$latest_version" > "$LATEST_VERSION_FILE"

  if [ "$current_version" != "$latest_version" ]; then
    printf 'yes'
  else
    printf 'no'
  fi
}


main() {
  if [ -z "$INSTALL_DIR" ]; then
    echo 'WARNING: INSTALL_DIR is unset!' 1>&2
    echo '         Assuming you want /opt/valheim_server' 1>&2
    INSTALL_DIR="/opt/valheim_server"
  fi

  if ! [ -e "$INSTALL_DIR"]; then
    echo 'INFO: $INSTALL_DIR does not exist. Installing...'
    do_update="yes"
  fi

  if [ -z "$do_update" ]; then
    if ! do_update="$(compare_versions)"; then
      echo "ERROR: there was an error attempting to update the server"
    fi
  fi

  if [ "$do_update" = "yes" ]; then
    echo "INFO: Server version unknown or out of date. Updating server"
    if ! update_server; then
      echo 'ERROR: could not update the server!' 1>&2
      exit 2
    fi
  elif [ "$do_update" = "no" ]; then
    echo "INFO: Server already up to date. Nothing to do."
  fi

  # update the version file after we have successfully updated
  # (and not forcefully exited)
  mv "$LATEST_VERSION_FILE" "$VERSION_FILE"
}

main "$@"
