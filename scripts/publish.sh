#!/usr/bin/env bash

set -euxo pipefail

IMAGE_NAME="${1:?no image name specified}"
DOCKER_USERNAME="${2:?no Docker Hub username specified}"

docker login --username "$DOCKER_USERNAME" --password-stdin
docker push "$IMAGE_NAME"
