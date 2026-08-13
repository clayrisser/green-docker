# syntax=docker/dockerfile:1

FROM node:22-alpine AS build

WORKDIR /opt/app

# Dependency manifests first so the install layer is cached until they change.
COPY nodejs/package.json nodejs/pnpm-lock.yaml ./
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack enable pnpm && \
    pnpm install --frozen-lockfile --prod

COPY nodejs/src ./src

FROM node:22-alpine

LABEL org.opencontainers.image.title="green-docker nodejs" \
      org.opencontainers.image.source="https://gitlab.com/bitspur/rock8s/green-docker" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache tini

ENV NODE_ENV=production

WORKDIR /opt/app
COPY --from=build /opt/app ./

USER node

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--", "node", "src/app.js"]
