# Client Certs

```sh
# Generate Client CA key and cert (use -nodes to remove pass phrase) to be provided to server
openssl req -x509 -nodes -newkey rsa:4096 -keyout clientCA.key \
  -days 1024 -out clientCA.crt \
  -subj "/C=SG/L=SG/OU=MyOU/O=MyOrg/CN=Client CA"

# Generiate client key and certificate request
openssl req -nodes -newkey rsa:2048 \
  -keyout client.key \
  -subj "/C=SG/L=SG/OU=MyOU/O=MyOrg/CN=user" \
  -out client.csr

# Sign client cert using CA
openssl x509 -req \
  -in client.csr \
  -CA clientCA.crt -CAkey clientCA.key -CAcreateserial \
  -out client.crt -days 365 -sha256
```
