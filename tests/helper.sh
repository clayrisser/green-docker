# Shared helpers for the bats smoke suite. POSIX sh.
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "${BATS_TEST_DIRNAME:-$(dirname -- "$0")}/.." && pwd)}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-registry.gitlab.com/bitspur/rock8s/green-docker}"
DOCKER_TAG="${DOCKER_TAG:-latest}"
export PROJECT_ROOT DOCKER_REGISTRY DOCKER_TAG

image_size_mb() {
  docker image inspect --format '{{.Size}}' "$1" | awk '{printf "%d", $1 / 1000000}'
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
