# Green Docker

![](assets/green-docker.png)

Make the most efficient Docker image using best practices

Cut back on greenhouse emissions by writing good code

Start by reading the [Dockerfile Guide](DOCKERFILE_GUIDE.md)

[Watch the Video](https://www.youtube.com/watch?v=2-wR_balsH0&t=525s)

## Features

* Multi-stage builds — only the runtime artifacts ship
* Tiny pinned base images (Alpine)
* Maximum layer caching (dependency manifests copied first, BuildKit cache mounts)
* Proper signal handling (tini as PID 1, graceful shutdown)
* Non-root runtime user
* `docker buildx bake` builds with a single bake file for every image
* Size-budget smoke tests (bats) that fail the build if an image bloats

## Layout

```
docker/
├── docker-bake.hcl      # all images, tags, and platforms in one place
├── Makefile             # make bake / make bake/<image>
├── nodejs/Dockerfile    # Node.js 22 + pnpm multi-stage example
└── python/Dockerfile    # Python 3.13 + uv multi-stage example
nodejs/                  # sample Express app
python/                  # sample Flask app
tests/                   # bats smoke tests (image size budget + HTTP)
```

## Dependencies

* [Docker](https://docker.com) with BuildKit (buildx)
* [asdf](https://asdf-vm.com) for the dev toolchain (`bats`, `shfmt`)

## Usage

```sh
make prepare    # one-time toolchain setup (asdf install)
make build      # build all images via buildx bake
make test/e2e   # build + assert image size budgets + HTTP smoke test
```

Build a single image:

```sh
make docker/bake/nodejs
make docker/bake/python
```

Push multi-arch (linux/amd64 + linux/arm64) images to the registry:

```sh
make build BAKE_OUTPUT=registry
```

## Support

Submit an [issue](https://gitlab.com/bitspur/rock8s/green-docker/-/issues/new)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a merge request :D

## License

[MIT License](LICENSE)

[Clay Risser](https://clayrisser.com) &copy; 2017-2026

## Credits

* [Clay Risser](https://clayrisser.com) - Author
* [Docker](https://docs.docker.com/reference/dockerfile)
