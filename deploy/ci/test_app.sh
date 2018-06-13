#!/bin/sh
set -e

CONTAINER_TEST_IMAGE="s3-json-secrest"

rm .dockerignore
docker build -t "$CONTAINER_TEST_IMAGE" .

docker run --entrypoint="" "$CONTAINER_TEST_IMAGE" rake test
