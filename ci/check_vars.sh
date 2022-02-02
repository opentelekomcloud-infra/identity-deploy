#!/usr/bin/env bash

function fail_if_unset() {
  if [ -z "${!1}" ]
  then
      printf "%s is not defined\n" "$1" >&2
      return 1
  else
      printf "%s is defined\n" "$1"
      return 0
  fi
}

fail_if_unset "OS_CLOUD" || exit 1
fail_if_unset "OS_CLIENT_CONFIG_FILE" || exit 2
