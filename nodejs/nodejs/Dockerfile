FROM node:8.11.3-alpine

LABEL image=codejamninja/green-docker:nodejs \
      maintainer="Jam Risser <jam@codejam.ninja>" \
      base=alpine:3.6

RUN apk add --no-cache \
        tini
RUN apk add --no-cache --virtual build-deps \
        build-base

WORKDIR /tmp/app

COPY /app/package.json ./
RUN yarn
COPY /app ./
RUN yarn build && \
    mv /tmp/app /opt/app && \
    apk del build-deps

WORKDIR /opt/app

ENV HELLO=world \
    HOWDY=texas

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--", "node", "dist/app.js"]
