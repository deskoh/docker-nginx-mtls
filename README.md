# Mutual TLS NGINX Reverse Proxy

```sh
# Start mTLS server with proxy to httpbin.org (see `.env` for environment variables)
docker-compose up

# Test server (ignore invalid CA)
curl -k --cert certs/client/client.crt --key certs/client/client.key https://localhost:8443/get

# Test server
curl --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443/get

curl -k https://localhost:8443
```

## ECS Fargate DNS Discovery

If `RESOLVER` is not defined, the startup script `50-get-dns.sh` will attempt to check if [Fargate Metadata Endpoint](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-metadata-endpoint-v4-fargate.html) is available for DNS discovery.

The data returned by the endpoint is in a single line and can be found in `test/data.json`. The data can be served using [`serve` npm package](https://www.npmjs.com/package/serve) for testing.

## Client / Server configuration

Server CA (trusted / loaded by client): `certs/server/serverCA.crt`

Server Cert (loaded by server): `/certs/server/server.crt`

Server Key (loaded by server): `/certs/server/server.key`

Client CA (trusted / loaded by server): `certs/server/clientCA.crt`

Client Cert (loaded by client): `/certs/client/client.crt`

Client Key (loaded by client): `/certs/client/client.key`
