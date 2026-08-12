#!/usr/bin/env bats
load helper.sh

@test "nodejs container responds on /" {
  run http_smoke "$DOCKER_REGISTRY/nodejs:$DOCKER_TAG" 3000
  [ "$status" -eq 0 ]
  [ "$output" = '{"hello":"world"}' ]
}

@test "python container responds on /" {
  run http_smoke "$DOCKER_REGISTRY/python:$DOCKER_TAG" 5000
  [ "$status" -eq 0 ]
  [ "$output" = '{"hello":"world"}' ]
}
