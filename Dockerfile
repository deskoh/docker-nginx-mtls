ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nginxinc/nginx-unprivileged
ARG BASE_TAG=stable-alpine

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

COPY ./config/*.inc /etc/nginx/
COPY ./config/default-mtls.conf /etc/nginx/conf.d/default.conf

COPY ./docker-entrypoint.d/ /docker-entrypoint.d/

USER root
RUN chmod +x /docker-entrypoint.d/40-write-certs.sh
USER nginx

ENV SERVER_CERT= \
    SERVER_KEY= \
    CLIENT_CA=
