# Dockerfile Guide

I based this guide on personal advice from [@creack](https://github.com/creack), co-creator of Docker, as well as my own
experience and mistakes building, deploying and maintaining hundreds of Dockerfiles. [@creak](https://github.com/creack)
was the [#1 contributor](https://github.com/moby/moby/graphs/contributors?from=2013-01-13&to=2014-01-31&type=c) to Docker
during its first year. I owe my enthusiasm with Docker to a day [@creak](https://github.com/creack) sat down with me and
showed me the ropes.

### Use multi-stage builds — always

This is the single highest-impact practice. Build in one stage with the full toolchain, then copy only the
runtime artifacts into a fresh minimal stage. Build dependencies, compilers, package-manager caches, and source
code never reach the final image. Both examples in this repo follow the pattern:

```dockerfile
FROM node:22-alpine AS build
# ... install deps, build ...

FROM node:22-alpine
COPY --from=build /opt/app ./
```

### Use a minimal base

Pick the smallest base that fits the job:

* [Alpine](https://hub.docker.com/_/alpine/) — tiny (~8 MB) with package management via `apk`. The default
  choice for most apps. Watch out for musl-vs-glibc issues with native binaries.
* [Debian slim](https://hub.docker.com/_/debian) (`*-slim` variants) — when you need glibc compatibility or
  prebuilt wheels/binaries that don't ship musl builds.
* [Distroless](https://github.com/GoogleContainerTools/distroless) or `FROM scratch` — no shell, no package
  manager, smallest attack surface. Great for static Go/Rust binaries; distroless also ships language runtimes.
  The trade-off is harder debugging (no shell to `exec` into).

### Use official images for the base

Official images help prevent unexpected bugs because a professional team of developers continually maintains them.

### Pin the base version

A base that is not versioned may change without you knowing, and could break the Docker image. Pin at least the
minor version (`node:22-alpine`, `python:3.13-alpine`). For fully reproducible, supply-chain-hardened builds,
pin the digest too (`python:3.13-alpine@sha256:…`) and let a bot like Renovate bump it.

### Order layers for the build cache

Since layers are cached, the build reuses them when nothing has changed in the current and previous layers.
Copy your dependency manifests first (`package.json` + lockfile, `pyproject.toml` + lockfile), install
dependencies, and only then copy the rest of the application. A source-only change then reuses the cached
dependency layer instead of reinstalling everything.

### Use BuildKit cache mounts for package managers

`RUN --mount=type=cache` keeps the package-manager download cache across builds without baking it into a layer:

```dockerfile
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev
```

Even when the dependency layer is invalidated, packages come from the local cache instead of the network.

### Install from a lockfile

`pnpm install --frozen-lockfile`, `uv sync --frozen`, `npm ci` — builds should be reproducible and fail loudly
when the manifest and lockfile drift apart.

### Clean up build dependencies in the same layer

If you must install build dependencies in the final stage, remove them in the same `RUN` instruction
(`apk add --virtual build-deps … && … && apk del build-deps`) — a later `RUN rm` does not shrink earlier
layers. With multi-stage builds this mostly takes care of itself: keep the toolchain in the build stage.

### Chain instructions where it helps the cache

Each Dockerfile instruction creates a layer. With BuildKit, minimizing layer *count* matters much less than it
used to — empty layers are free and caching is smarter. Chain commands with `&&` when they form one logical
step (install + cleanup), not to golf the layer count at the cost of readability.

### Run as a non-root user

Create (or reuse) an unprivileged user and switch to it with `USER` before the entrypoint. A container escape
from root in the container is a much bigger problem than one from an unprivileged user.

### Catch termination signals

PID 1 in a container does not get default signal handling, so a naive entrypoint ignores `CTRL-C` and
`docker stop` waits 10 seconds then `SIGKILL`s your app. Use [tini](https://github.com/krallin/tini) as the
entrypoint (or `docker run --init`) to forward signals and reap zombies, and handle `SIGTERM`/`SIGINT` in your
app for graceful shutdown. Always use the exec form (`ENTRYPOINT ["…"]`) — the shell form wraps your process in
`/bin/sh`, which swallows signals.

### Use ENTRYPOINT and CMD correctly

Use `ENTRYPOINT` for running your main program, and `CMD` to pass the default arguments. This practice ensures
the user can override the arguments without needing to know how to run the program.

### Stick to Linux conventions

Docker images share the Linux kernel with the host machine. Because a Docker image is essentially a Linux
system, use Linux conventions when possible. Put binaries in `/usr/local/bin`. Put source code in
`/usr/local/src`. Put applications in `/opt` — this repo places the main app in `/opt/app`.

### Keep the build context small with .dockerignore

Everything in the build context is sent to the builder and can invalidate `COPY` caches. Ship a
`.dockerignore` that excludes `node_modules`, virtualenvs, `.git`, and build output. This repo generates
`.dockerignore` from `.gitignore` so the two never drift.

### Label images with OCI annotations

Use the standard [OCI annotation keys](https://github.com/opencontainers/image-spec/blob/main/annotations.md)
(`org.opencontainers.image.source`, `…licenses`, etc.) instead of ad-hoc `LABEL` names — registries and
scanners understand them.

### Build with buildx bake

Define every image, tag, and platform once in `docker-bake.hcl` instead of scattering `docker build` flags
across scripts. `docker buildx bake` builds them all (in parallel, multi-arch via `--set '*.platform=…'`) and
the same file drives local loads and registry pushes.

### Attest what you ship

BuildKit can generate and attach SBOM and provenance attestations at build time (`--sbom=true`,
`--provenance=mode=max`) for images pushed to a registry. For local `--load` builds, disable provenance
(`--provenance=false`) — the local image store can't hold the attestation manifest.
