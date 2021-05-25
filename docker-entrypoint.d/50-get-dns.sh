#!/bin/sh

if [ ! -z "$RESOLVER" ]; then
  echo "Environment variable RESOLVER found: $RESOLVER"
  exit 0
fi

# https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-metadata-endpoint-v4-fargate.html
if [ -z "$ECS_CONTAINER_METADATA_URI_V4" ]; then
  exit 0
fi

echo " Discovering DNS using Fargate Task metadata endpoint v4 found..."
RESOLVER=$(curl -s $ECS_CONTAINER_METADATA_URI_V4 | sed 's|.*DomainNameServers||'  | awk -F \" '{print $3}')
echo "DNS found at $RESOLVER"

RESOLVER=$RESOLVER /docker-entrypoint.d/20-envsubst-on-templates.sh
