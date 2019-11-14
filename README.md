# docker-node-chromium-alpine

A Docker image with preinstalled Chromium and Node.JS on Alpine Linux.
Good minimal base image for users of scraping libraries like
[Puppeteer](https://github.com/GoogleChrome/puppeteer/).

## Tags

See all tags at [Docker Hub
(shivjm/node-chromium-alpine)](https://hub.docker.com/repository/docker/shivjm/node-chromium-alpine).

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
FROM node:13-alpine

WORKDIR /usr/src/app-deps

COPY package.json package-lock.json ./

RUN npm ci --quiet

RUN npm run --quiet compile-my-code

RUN npm prune --quiet --production

FROM shivjm/node-chromium-alpine:13

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

COPY --from=build /usr/src/app-deps/node_modules ./node_modules

COPY --from=build /usr/src/app-deps/dist ./dist

ENV NODE_ENV=production

ENTRYPOINT ["npm", "start", "--quiet"]
```
