#!/usr/bin/env bats
load helper.sh

setup_file() {
  make -C "$PROJECT_ROOT" build
}

@test "nodejs image is under 250 MB" {
  run image_size_mb "$DOCKER_REGISTRY/nodejs:$DOCKER_TAG"
  [ "$status" -eq 0 ]
  echo "nodejs image size: ${output} MB" >&3
  [ "$output" -lt 250 ]
}

@test "python image is under 100 MB" {
  run image_size_mb "$DOCKER_REGISTRY/python:$DOCKER_TAG"
  [ "$status" -eq 0 ]
  echo "python image size: ${output} MB" >&3
  [ "$output" -lt 100 ]
}
