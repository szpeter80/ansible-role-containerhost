#!/bin/bash
# This script is executed at every (re)start of the respective project systemd unit
# Errors are not regarded, 


# shellcheck disable=SC1091
. ../environment.env

echo "PRE-START"

CERTBOT_DIR="./certbot/certs/live/${C_HOST_NAME}"
cert_pem="${CERTBOT_DIR}/cert.pem"
privkey_pem="${CERTBOT_DIR}/privkey.pem"

if [[ ! -f "${cert_pem}" || ! -r "${cert_pem}" || ! -f "${privkey_pem}" || ! -r "${privkey_pem}" ]]; then
  echo "pre-start: certbot files missing or unreadable under ${CERTBOT_DIR} for ${C_HOST_NAME}, skipping PEM merge" >&2
  exit 0
fi

cat "${cert_pem}" > "./certs/${C_HOST_NAME}.pem"
cat "${privkey_pem}" >> "./certs/${C_HOST_NAME}.pem"
