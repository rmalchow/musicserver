#!/bin/bash
set -e
set +x 
docker login -u "${DH_USER}" -p "${DH_PW}"

docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t rmalchow/mopidy:latest -f Dockerfile-mopidy .
docker push rmalchow/mopidy:latest
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t rmalchow/snapserver:latest -f Dockerfile-snapserver .
docker push rmalchow/snapserver:latest
