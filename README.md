# Mutual TLS NGINX Reverse Proxy

## Quick Start

```sh
# Start mTLS server with default index page
docker run --name nginx-mtls -d -p 8443:8443 --restart=unless-stopped \
  -v `pwd`/certs/server/server.crt:/etc/nginx/certs/server.crt:ro \
  -v `pwd`/certs/server/server.key:/etc/nginx/certs/server.key:ro \
  -v `pwd`/certs/client/clientCA.crt:/etc/nginx/certs/clientCA.crt:ro \
  -v `pwd`/config/ssl_config.inc:/etc/nginx/ssl_config.inc:ro \
  -v `pwd`/config/conf.d/default-mtls.conf:/etc/nginx/conf.d/default.conf:ro \
  nginxinc/nginx-unprivileged:stable-alpine

# Test server (ignore invalid CA)
curl -k --cert certs/client/client.crt --key certs/client/client.key https://localhost:8443

# Test server
curl --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443

# Verify server cert
openssl s_client -CAfile certs/server/serverCA.crt -connect localhost:8443
```

## mTLS Proxy

See `.env` for environment variables.

```sh
# Use `docker-compose config` to review values.
docker-compose up -d

# Proxy to httpbin.org
curl -k --cert certs/client/client.crt --key certs/client/client.key https://localhost:8443/get

# Test server
curl --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443/get

# Verify server cert
openssl s_client -CAfile certs/server/serverCA.crt -connect localhost:8443
```

## Client / Server configuration

Server CA (trusted / loaded by client): `certs/server/serverCA.crt`

Server Cert (loaded by server): `/certs/server/server.crt`

Server Key (loaded by server): `/certs/server/server.key`

Client CA (trusted / loaded by server): `certs/server/clientCA.crt`

Client Cert (loaded by client): `/certs/client/client.crt`

Client Key (loaded by client): `/certs/client/client.key`


## Reference

[Using DNS for Service Discovery with NGINX and NGINX Plus](https://www.nginx.com/blog/dns-service-discovery-nginx-plus/)

[SSL Termination for TCP Upstream Servers](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/)
