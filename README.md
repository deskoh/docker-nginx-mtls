# Mutual TLS NGINX Reverse Proxy

```sh
# Start server with proxy to 192.168.1.1:80 (mount /config/default-mtls.conf to serve default index)
docker run --name nginx-mtls -d -p 8443:8443 --restart=unless-stopped \
  -v `pwd`/certs/server/tls.crt:/etc/nginx/certs/tls.crt:ro \
  -v `pwd`/certs/server/server.key:/etc/nginx/certs/tls.key:ro \
  -v `pwd`/certs/client/clientCA.crt:/etc/nginx/certs/clientCA.crt:ro \
  -v `pwd`/config/proxy-mtls.conf:/etc/nginx/conf.d/default.conf:ro \
  p.cr.io/base/nginx

# Test server (ignore invalid CN)
curl -k --cert certs/client/client.crt --key certs/client/client.key https://localhost:8443/

# Test server
curl -k --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443/

curl -k https://localhost:8443
```

## Client / Server configuration

Server CA (trusted / loaded by client): `certs/server/serverCA.crt`

Server Cert (loaded by server): `/certs/server/server.crt`

Server Key (loaded by server): `/certs/server/server.key`

Client CA (trusted / loaded by server): `certs/server/clientCA.crt`

Client Cert (loaded by client): `/certs/client/client.crt`

Client Key (loaded by client): `/certs/client/client.key`

## Inject Certs using Environment Variables

```sh
# Certs are in `.env` files.

# Build images and run containers
docker-compose up

# Build images only
docker-compose build

# Clean up
docker-compose down
```
