#!/bin/bash

set -e

apt-get update

apt-get install -y wget apt-utils ca-certificates

arch=$(arch)

if [ "x86_64" == ${arch} ]; then
  arch="amd64"
else if [ "armv7l" == ${arch} ]; then
  arch="armhf"
else if [ "aarch64" == ${arch} ]; then
  arch="armhf"
else
  echo "unknow arch: ${arch}"
  exit
fi

wget https://github.com/badaix/snapcast/releases/download/v0.22.0/snapserver_0.22.0-1_${arch}.deb
dpkg -i snapserver_* || true
apt-get update
apt-get -f install -y

rm -rf /var/lib/apt/lists/*
rm -rf /root/.cache/*
