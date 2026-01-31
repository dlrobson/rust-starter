#!/usr/bin/env sh
set -eu

# Initialize devcontainer environment
# This script is run before the container is built

cd "$(dirname "$0")"

# Create compose.override.yaml if it doesn't exist
touch -a compose.override.yaml

# Extract docker GID
DOCKER_GID=$(getent group docker | cut -d: -f3)

# Extract repository name from git remote URL
REPO_NAME=$(git -C .. config --get remote.origin.url | sed 's/.*\/\([^/]*\)\.git$/\1/' | sed 's/.*\/\([^/]*\)$/\1/')

# Recreate .env file with docker GID and repo name
{
  echo "DOCKER_GID=${DOCKER_GID}"
  echo "REPO_NAME=${REPO_NAME}"
} > .env

echo "Devcontainer initialization complete"