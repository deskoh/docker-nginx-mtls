#!/bin/sh

[[ -z "$SERVER_CA" ]] && echo "Environment variable SERVER_CA not defined" && exit 1
[[ -z "$SERVER_KEY" ]] && echo "Environment variable SERVER_KEY not defined" && exit 1
[[ -z "$CLIENT_CA" ]] && echo "Environment variable CLIENT_CA not defined" && exit 1

# Need quotes to echo multi-line env var
mkdir -p /etc/nginx/certs/
[[ ! -z "$SERVER_CA" ]] && echo "$SERVER_CA" > /etc/nginx/certs/tls.crt
[[ ! -z "$SERVER_KEY" ]] && echo "$SERVER_KEY" > /etc/nginx/certs/tls.key
[[ ! -z "$CLIENT_CA" ]] && echo "$CLIENT_CA" > /etc/nginx/certs/clientCA.crt

# Forward args to CMD
exec "$@"
