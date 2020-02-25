#!/bin/sh
set -e

CONTAINER_TEST_IMAGE="victoriatreasure-test"

mv .dockerignore deploy
docker build -t "$CONTAINER_TEST_IMAGE" .

docker run --entrypoint="" "$CONTAINER_TEST_IMAGE" rake test

mv deploy/.dockerignore .