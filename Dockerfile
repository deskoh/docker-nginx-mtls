ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nginxinc/nginx-unprivileged
ARG BASE_TAG=stable-alpine

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

COPY ./config/default-mtls.conf /etc/nginx/conf.d/default.conf

COPY entrypoint.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/entrypoint.sh
USER nginx

ENV SERVER_CA= \
    SERVER_KEY= \
    CLIENT_CA=

ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]
