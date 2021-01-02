#!/bin/bash
cd $(dirname $0)
export home=$(pwd)
echo "home directory is: ${home}"
if [ -f "${home}/config/mopidy.conf" ]; then
  echo "using config: ${home}/config/mopidy.conf"
else
  mkdir -p config
  cp ${home}/mopidy.conf ${home}/config/
fi

docker-compose pull
./stop.sh
docker-compose up -d
