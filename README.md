# docker-node-chromium

[![Build and publish to Docker Hub](https://github.com/shivjm/docker-node-chromium/actions/workflows/publish.yml/badge.svg)](https://github.com/shivjm/docker-node-chromium/actions/workflows/publish.yml) ![https://hub.docker.com/r/shivjm/node-chromium](https://img.shields.io/docker/pulls/shivjm/node-chromium)

A Docker image with preinstalled Chromium and Node.JS on Alpine Linux or Debian. Good minimal base image for users of scraping libraries like [Puppeteer](https://github.com/GoogleChrome/puppeteer/).

## Repository

https://github.com/shivjm/docker-node-chromium/

## Issues

https://github.com/shivjm/docker-node-chromium/issues/

## Tags

See all available tags at [Docker Hub (shivjm/node-chromium)](https://hub.docker.com/r/shivjm/node-chromium). No `latest` image is provided.

### Alpine Linux

<code>node<var>N</var>-chromium<var>C</var>-alpine</code>, where <var>N</var> is the Node.js major version number (12, 14, 16, 17, 18, 19, 20, or 22) and <var>C</var> is the Chromium major version number. For example, to use Node.js 14 with Chromium 81, use the `shivjm/node-chromium:node14-chromium81-alpine` image.

### Debian

<code>node<var>N</var>-chromium<var>C</var>-debian</code>, where <var>N</var> is the Node.js major version number (12, 14, 16, 17, 18, 19, 20, or 22) and <var>C</var> is the Chromium major version number. For example, to use Node.js 14 with Chromium 81, use the `shivjm/node-chromium:node14-chromium81-debian` image.

## Versioning

The newest version of Chromium provided by Alpine Linux or Debian is used.

The version of the base distribution depends on [the upstream Node images](https://hub.docker.com/_/node?tab=tags&page=1&ordering=last_updated).

## Example Dockerfiles

Simple:

```Dockerfile
FROM shivjm/node-chromium:node14-chromium99-alpine

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm ci

COPY src .

ENTRYPOINT ["npm", "start"]
```

Multi-stage build to separate development dependencies from
production:

```Dockerfile
FROM node:12-alpine AS build

WORKDIR /usr/src/app-deps

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run compile-my-code && \
  npm prune --production

FROM shivjm/node-chromium:node18-chromium108-debian

USER node

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

COPY --from=build /usr/src/app-deps/node_modules ./node_modules

COPY --from=build /usr/src/app-deps/dist ./dist

ENV NODE_ENV=production

ENTRYPOINT ["npm", "start", "--quiet"]
```

## Puppeteer

When you install Puppeteer, it also downloads a known version of Chromium to store under node_modules, and defaults to using that binary. You can skip this download using the environment variable `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD`. You’ll also need to set `PUPPETEER_EXECUTABLE_PATH` to the installed Chromium. A partial example:

```Dockerfile
# (setup elided)

# install dependencies but not Chromium:

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

RUN npm install

# make Puppeteer use correct binary:

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# (other build details elided)
```
