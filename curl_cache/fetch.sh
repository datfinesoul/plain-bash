#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# show commands (debug)
#set -x

function cleanup {
  echo cleanup
  #rm -rf /tmp/curl_cache
}

trap cleanup EXIT

function curl_cache {
  local ROOT="/tmp/curl_cache"
  local DURATION_IN_SECONDS="${1:-60}"
  local URL="${2}"
  mkdir -p "${ROOT}"
  local CACHE="${ROOT}/$(echo -n ${URL} | sha256sum | cut -f1 -d' ')"
  find "${CACHE}" -type f -not -newermt "-${DURATION_IN_SECONDS} seconds" -delete 2>&1 > /dev/null || true
  if [[ ! -f "${CACHE}" ]]; then
    echo "fetching ${URL}"
    curl -sS "${URL}" 2> /dev/null 1> "${CACHE}"
  fi
  cat "${CACHE}"
}
curl_cache 7 https://raw.githubusercontent.com/datfinesoul/plain.bash/master/README.md
