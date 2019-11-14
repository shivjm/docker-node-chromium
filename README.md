# docker-node-chromium-alpine

A Docker image with preinstalled Chromium and Node.JS on Alpine Linux.
Good minimal base image for users of scraping libraries like
[Puppeteer](https://github.com/GoogleChrome/puppeteer/).

## Tags

See all tags at [Docker Hub
(shivjm/node-chromium-alpine)](https://hub.docker.com/repository/docker/shivjm/node-chromium-alpine).

## Example Dockerfile

```Dockerfile
FROM shivjm/node-chromium-alpine

WORKDIR /usr/src/app

COPY package.json package-lock.json .

RUN npm ci

COPY src .

ENTRYPOINT ["npm", "start"]
```
