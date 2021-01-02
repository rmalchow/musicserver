#!/bin/bash
cd $(dirname $0)
export home=$(pwd)
echo "home directory is: ${home}"
docker-compose pull
./stop.sh
docker-compose up -d
