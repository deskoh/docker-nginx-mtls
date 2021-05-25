#!/bin/sh

[[ -z "$SERVER_CERT" ]] && echo "Environment variable SERVER_CERT not defined" && exit 1
[[ -z "$SERVER_KEY" ]] && echo "Environment variable SERVER_KEY not defined" && exit 1
[[ -z "$CLIENT_CA" ]] && echo "Environment variable CLIENT_CA not defined" && exit 1

# Need quotes to echo multi-line env var
mkdir -p /etc/nginx/certs/
[[ ! -z "$SERVER_CERT" ]] && echo "$SERVER_CERT" > /etc/nginx/certs/server.crt
[[ ! -z "$SERVER_KEY" ]] && echo "$SERVER_KEY" > /etc/nginx/certs/server.key
[[ ! -z "$CLIENT_CA" ]] && echo "$CLIENT_CA" > /etc/nginx/certs/clientCA.crt

# Forward args to CMD
exec "$@"
