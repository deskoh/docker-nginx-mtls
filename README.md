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

## ECS Fargate DNS Discovery

If `RESOLVER` is not defined, the startup script `50-get-dns.sh` will attempt to check if [Fargate Metadata Endpoint](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-metadata-endpoint-v4-fargate.html) is available to discover the DNS.

The data returned by the endpoint is in a single line and can be found in `test/data.json`. The data can be served using [`serve` npm package](https://www.npmjs.com/package/serve) for testing.

## Client / Server configuration

Server CA (trusted / loaded by client): `certs/server/serverCA.crt`

Server Cert (loaded by server): `/certs/server/server.crt`

Server Key (loaded by server): `/certs/server/server.key`

Client CA (trusted / loaded by server): `certs/server/clientCA.crt`

Client Cert (loaded by client): `/certs/client/client.crt`

Client Key (loaded by client): `/certs/client/client.key`

## PROXY Protocol

To enable [PROXY protocol](https://docs.nginx.com/nginx/admin-guide/load-balancer/using-proxy-protocol/), set environment variable `PROXY_PROTOCOL=proxy_protocol`.

## Logs of Interest

```txt
2021/01/01 10:00:01 [warn] 56#56: *15086 upstream server temporarily disabled while connecting to upstream, client: 111.111.111.111, server: 0.0.0.0:8443, upstream: "100.100.100.100:80", bytes from/to client:75/0, bytes from/to upstream:0/0
2021/01/01 10:00:02 [error] 56#56: *15086 upstream timed out (110: Operation timed out) while connecting to upstream, client: 111.111.111.111, server: 0.0.0.0:8443, upstream: "100.100.100.100:80", bytes from/to client:75/0, bytes from/to upstream:0/0
2021/01/01 10:00:03 [crit] 56#56: *2521 SSL_shutdown() failed (SSL: error:14094123:SSL routines:ssl3_read_bytes:application data after close notify) while SSL handshaking, client: 111.111.111.111, server: 0.0.0.0:8443
```

## Reference

[Using DNS for Service Discovery with NGINX and NGINX Plus](https://www.nginx.com/blog/dns-service-discovery-nginx-plus/)

[SSL Termination for TCP Upstream Servers](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/)

[TCP/UDP Load Balancing with NGINX: Overview, Tips, and Tricks](https://www.nginx.com/blog/tcp-load-balancing-udp-load-balancing-nginx-tips-tricks/)

[AWS ELB: Proxy Protocol](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol)
