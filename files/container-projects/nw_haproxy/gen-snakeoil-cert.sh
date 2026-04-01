#!/bin/bash

# shellcheck disable=SC1091
. ../environment.env

openssl req -new \
    -newkey rsa:4096 -nodes -keyout ./certs/snakeoil.key \
    -out ./certs/snakeoil.csr \
    -subj "/C=US/ST=Krakosia/L=City/O=ACME corp/CN=${C_HOST_NAME}" \
    -addext "subjectAltName=DNS:${C_HOST_NAME},DNS:*.${C_HOST_NAME},IP:${C_HOST_ADDRESS}"

# Blindly copying extensions from the CSR is a bad practice for a real CA, but will do for a dummy one
openssl x509 -req -days 3650 -in ./certs/snakeoil.csr -signkey ./certs/snakeoil.key -out ./certs/snakeoil.crt -copy_extensions copyall

cat ./certs/snakeoil.crt >> ./certs/snakeoil.pem
cat ./certs/snakeoil.key >> ./certs/snakeoil.pem

rm -f ./certs/snakeoil.csr
rm -f ./certs/snakeoil.crt
rm -f ./certs/snakeoil.key