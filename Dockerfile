# Based upon:
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-on-alpine

ARG NODE_VERSION

ARG BUILD_DATE

FROM node:${NODE_VERSION}-alpine

LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Shiv Jha-Mathur" \
      org.opencontainers.image.source="https://github.com/shivjm/docker-node-chromium-alpine/" \
      org.opencontainers.image.title="node-chromium-alpine" \
      org.opencontainers.image.description="A minimal Docker image with Node and Chromium on Alpine Linux"

RUN apk add -q --update --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      yarn
