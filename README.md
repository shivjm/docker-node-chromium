# docker-node-chromium-alpine

![](https://img.shields.io/github/workflow/status/shivjm/docker-node-chromium-alpine/Build%20and%20publish%20to%20Docker%20Hub) ![](https://img.shields.io/docker/pulls/shivjm/node-chromium-alpine)

A Docker image with preinstalled Chromium and Node.JS on Alpine Linux.
Good minimal base image for users of scraping libraries like
[Puppeteer](https://github.com/GoogleChrome/puppeteer/).

## Repository

https://github.com/shivjm/docker-node-chromium-alpine/

## Issues

https://github.com/shivjm/docker-node-chromium-alpine/issues/

## Tags

<code>node<var>N</var>-chromium<var>C</var></code>, where <var>N</var> is the Node.js major version number (8, 10, 12, 13, or 14) and <var>C</var> is the Chromium major version number. For example, to use Node.js 14 with Chromium 81, use the `shivjm/node-chromium-alpine:node14-chromium81` image. No `latest` image is provided.

See all available tags at [Docker Hub (shivjm/node-chromium-alpine)](https://hub.docker.com/repository/docker/shivjm/node-chromium-alpine).

## Versioning

The newest version of Chromium provided by Alpine Linux is used.

The version of Alpine Linux depends on [the upstream <code>node:<var>N</var>-alpine</code> image](https://hub.docker.com/_/node?tab=tags&page=1&ordering=last_updated&name=alpine).

## Example Dockerfiles

Simple:

```Dockerfile
FROM shivjm/node-chromium-alpine

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm ci

COPY src .

ENTRYPOINT ["npm", "start"]
```

Multi-stage build to separate development dependencies from
production:

```Dockerfile
FROM node:12-alpine

WORKDIR /usr/src/app-deps

COPY package.json package-lock.json ./

RUN npm ci --quiet

COPY . .

RUN npm run --quiet compile-my-code && \
  npm prune --quiet --production

FROM shivjm/node-chromium-alpine:12

USER node

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

COPY --from=build /usr/src/app-deps/node_modules ./node_modules

COPY --from=build /usr/src/app-deps/dist ./dist

ENV NODE_ENV=production

ENTRYPOINT ["npm", "start", "--quiet"]
```

## Puppeteer

When you install Puppeteer, it also downloads a known version of
Chromium to store under node_modules, and defaults to using that
binary. You can skip this download using the environment variable
`PUPPETEER_SKIP_CHROMIUM_DOWNLOAD`. You’ll also need to set
`PUPPETEER_EXECUTABLE_PATH` to the installed Chromium. A partial
example:

```Dockerfile
# (setup elided)

# install dependencies but not Chromium:

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

RUN npm install

# make Puppeteer use correct binary:

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# (other build details elided)
```
