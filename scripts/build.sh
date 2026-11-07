#!/usr/bin/env bash

set -euxo pipefail

IMAGE_VARIANT="${1:?no image variant specified}"
NODE_VERSION="${2:?no Node version specified}"
IMAGE_NAME="${3:?no base image name specified}"

DATETIME=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
IMAGE_WITHOUT_CHROMIUM_VERSION="$IMAGE_NAME:node$NODE_VERSION-$IMAGE_VARIANT"

# TODO: see about SBOMs and attestations
podman build -t "$IMAGE_WITHOUT_CHROMIUM_VERSION" --build-arg NODE_VERSION="$NODE_VERSION" --label "org.opencontainers.image.created=$DATETIME" --layers --cache-from "$IMAGE_WITHOUT_CHROMIUM_VERSION" --cache-to "$IMAGE_WITHOUT_CHROMIUM_VERSION"
CHROMIUM_VERSION=$(docker run --rm -t "$IMAGE_WITHOUT_CHROMIUM_VERSION" cat /etc/chromium-version | cut -d ' ' -f 2 | cut -d '.' -f 1)
echo "$IMAGE_NAME:node$NODE_VERSION-chromium$CHROMIUM_VERSION-$IMAGE_VARIANT"
