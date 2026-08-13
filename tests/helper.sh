# Shared helpers for the bats smoke suite. POSIX sh.
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "${BATS_TEST_DIRNAME:-$(dirname -- "$0")}/.." && pwd)}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-registry.gitlab.com/bitspur/rock8s/green-docker}"
DOCKER_TAG="${DOCKER_TAG:-latest}"
export PROJECT_ROOT DOCKER_REGISTRY DOCKER_TAG

# Unpacked size of the image's filesystem, in MB. `docker image inspect
# '{{.Size}}'` is not usable here: under the containerd image store it sums the
# compressed layer blobs, under the classic overlay2 store the unpacked layer
# diffs — about 3x apart for the same image, so the budget would mean something
# different depending on which store the host happens to run. Exporting the
# flattened rootfs is byte-identical on both.
image_size_mb() {
  cid=$(docker create "$1") || return 1
  bytes=$(docker export "$cid" | wc -c)
  docker rm -f "$cid" >/dev/null 2>&1
  printf '%s' "$bytes" | awk '{printf "%d", $1 / 1000000}'
}

# Start a container publishing $2 on a random loopback port, wait for an HTTP
# response on /, and print the response body. Container is removed on return.
http_smoke() {
  cid=$(docker run -d --rm -p "127.0.0.1::$2" "$1")
  port=$(docker port "$cid" "$2" | head -n1 | awk -F: '{print $NF}')
  body=""
  i=0
  while [ "$i" -lt 30 ]; do
    body=$(curl -fsS "http://127.0.0.1:$port/" 2>/dev/null) && break
    i=$((i + 1))
    sleep 1
  done
  docker stop "$cid" >/dev/null 2>&1
  [ -n "$body" ] && printf '%s' "$body"
}
