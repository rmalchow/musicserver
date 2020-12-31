#!/bin/bash
set -e

docker build -t rmalchow/mopidy:latest -f Dockerfile-mopidy .
docker login -u "${DH_USER}" -p "${DH_PW}"
docker push rmalchow/${CI_PROJECT_NAME}:latest
