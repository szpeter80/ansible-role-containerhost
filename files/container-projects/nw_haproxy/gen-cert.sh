#!/bin/bash

# shellcheck disable=SC1091
. ../environment.env

openssl req -new \
    -newkey rsa:4096 -nodes -keyout "./certs/${C_HOST_NAME}.key" \
    -out "./certs/${C_HOST_NAME}.csr" \
    -subj "/C=US/ST=Krakosia/L=City/O=ACME corp/CN=${C_HOST_NAME}" \
    -addext "subjectAltName=DNS:${C_HOST_NAME},DNS:*.${C_HOST_NAME},IP:${C_HOST_ADDRESS}"

# Blindly copying extensions from the CSR is a bad practice for a real CA, but will do for a dummy one
openssl x509 -req -days 3650 -in "./certs/${C_HOST_NAME}.csr" -signkey "./certs/${C_HOST_NAME}.key" -out "./certs/${C_HOST_NAME}.crt" -copy_extensions copyall
mv "./certs/${C_HOST_NAME}.csr" ./

cat "./certs/${C_HOST_NAME}.crt" >> "./certs/${C_HOST_NAME}.pem"
rm -f "./certs/${C_HOST_NAME}.crt"

cat "./certs/${C_HOST_NAME}.key" >> "./certs/${C_HOST_NAME}.pem"
rm -f "./certs/${C_HOST_NAME}.key"