#!/bin/bash

TAG=0.1.$CIRCLE_BUILD_NUM
docker build -t circleci-demo-docker:$TAG .
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
docker push circleci-demo-docker:$TAG

# $ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.17 bash
# $ for GOOS in darwin linux; do
# >   for GOARCH in 386 amd64; do
# >     export GOOS GOARCH
# >     go build -v -o myapp-$GOOS-$GOARCH
# >   done
# > done