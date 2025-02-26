#!/bin/bash

# Stop and remove containers, networks, images, and volumes
if ! docker compose down; then
  echo "Failed to stop and remove containers, networks, images, and volumes"
  exit 1
fi

# Remove all networks except predefined ones
networks=$(docker network ls -q | grep -vE '^(bridge|host|none)$')
if [ -n "$networks" ]; then
  if ! docker network rm "$networks"; then
    echo "Failed to remove networks"
    exit 1
  fi
else
  echo "No networks to remove"
fi

# Remove all containers
containers=$(docker ps -aq)
if [ -n "$containers" ]; then
  if ! docker rm -f "$containers"; then
    echo "Failed to remove containers"
    exit 1
  fi
else
  echo "No containers to remove"
fi

echo "Docker cleanup completed successfully"
