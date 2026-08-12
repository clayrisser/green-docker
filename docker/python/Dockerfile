# syntax=docker/dockerfile:1

FROM python:3.13-alpine AS build

COPY --from=ghcr.io/astral-sh/uv:0.8 /uv /usr/local/bin/uv

WORKDIR /opt/app

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=0

# Dependency manifests first so the sync layer is cached until they change.
COPY python/pyproject.toml python/uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

COPY python/server.py ./

FROM python:3.13-alpine

LABEL org.opencontainers.image.title="green-docker python" \
      org.opencontainers.image.source="https://gitlab.com/bitspur/rock8s/green-docker" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache tini && \
    adduser -D -H app

WORKDIR /opt/app
COPY --from=build /opt/app ./

ENV PATH="/opt/app/.venv/bin:$PATH"

USER app

EXPOSE 5000

ENTRYPOINT ["/sbin/tini", "--", "python", "server.py"]
