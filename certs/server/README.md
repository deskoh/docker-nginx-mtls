# Server certs

```sh
# Generate CA key and cert (use -nodes to remove pass phrase)
openssl req -x509 -nodes -newkey rsa:4096 -keyout serverCA.key \
  -days 1024 -out serverCA.crt \
  -subj "/C=SG/L=SG/OU=MyOU/O=MyOrg/CN=Server CA"

# Generate server key and CSR (Run in windows as v3 ext requires OpenSSL v1.1)
openssl req -nodes -newkey rsa:2048 \
  -keyout server.key \
  -subj "/C=SG/L=Singapore/O=MyOrg, Inc./CN=server" \
  -addext "subjectAltName=DNS:localhost,DNS:*.127.0.0.1.nip.io,IP:127.0.0.1" \
  -addext "keyUsage=digitalSignature,keyEncipherment" \
  -addext "basicConstraints=CA:false" \
  -out server.csr

# Sign server certificate using CA key and cert (see below for ssl.conf)
openssl x509 -req \
  -in server.csr \
  -CA serverCA.crt -CAkey serverCA.key -CAcreateserial \
  -out server.crt -days 1825 -sha256 \
  -extfile ssl.conf -extensions v3_ca


# Optional: Concatenate certs chain for nginx (or seems like server.crt will also suffice)
cat server.crt > tls2.crt
cat serverCA.crt >> tls2.crt
```
