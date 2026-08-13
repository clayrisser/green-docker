#!/usr/bin/env bats
# Budgets are the measured unpacked size plus roughly 12% headroom, which
# absorbs base-image patch drift and the few MB that separate the two arches
# without leaving room for a new dependency or a non-alpine base to slip in.
# Measured 2026-08 (linux/arm64, linux/amd64): nodejs 166 / 170 MB, python
# 56 / 52 MB. Raise a budget only alongside the measurement that justifies it.
load helper.sh

setup_file() {
  make -C "$PROJECT_ROOT" build
}

@test "nodejs image unpacks to under 190 MB" {
  run image_size_mb "$DOCKER_REGISTRY/nodejs:$DOCKER_TAG"
  [ "$status" -eq 0 ]
  echo "nodejs unpacked image size: ${output} MB" >&3
  [ "$output" -lt 190 ]
}

@test "python image unpacks to under 65 MB" {
  run image_size_mb "$DOCKER_REGISTRY/python:$DOCKER_TAG"
  [ "$status" -eq 0 ]
  echo "python unpacked image size: ${output} MB" >&3
  [ "$output" -lt 65 ]
}
