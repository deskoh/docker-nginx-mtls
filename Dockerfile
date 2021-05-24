ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nginxinc/nginx-unprivileged
ARG BASE_TAG=stable-alpine

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

COPY ./config/*.inc /etc/nginx/
COPY ./config/templates/nginx.conf /etc/nginx/templates/nginx.conf.template

COPY ./docker-entrypoint.d/ /docker-entrypoint.d/

USER root
RUN chmod +x /docker-entrypoint.d/40-write-certs.sh
RUN chmod +x /docker-entrypoint.d/50-get-dns.sh
USER nginx

ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx

ENV SERVER_CERT= \
    SERVER_KEY= \
    CLIENT_CA= \
    PROXY_PROTOCOL= \
    RESOLVER=1.1.1.1 \
    PROXY_URL=httpbin.org \
    PROXY_PORT=80
