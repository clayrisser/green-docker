variable "BAKE_OUTPUT" {}
variable "DOCKER_REGISTRY" {}
variable "DOCKER_TAG" {}
variable "GIT_COMMIT" {}

group "default" {
  targets = ["nodejs", "python"]
}

target "_common" {
  context = ".."
  output  = ["type=${BAKE_OUTPUT}"]
}

target "nodejs" {
  inherits   = ["_common"]
  dockerfile = "docker/nodejs/Dockerfile"
  tags = [
    "${DOCKER_REGISTRY}/nodejs:${DOCKER_TAG}",
    "${DOCKER_REGISTRY}/nodejs:${GIT_COMMIT}",
  ]
}

target "python" {
  inherits   = ["_common"]
  dockerfile = "docker/python/Dockerfile"
  tags = [
    "${DOCKER_REGISTRY}/python:${DOCKER_TAG}",
    "${DOCKER_REGISTRY}/python:${GIT_COMMIT}",
  ]
}
