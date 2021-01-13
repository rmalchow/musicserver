#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

echo "installing basics ... "
apt-get update
apt-get install -y apt-utils
apt-get install -y \
  wget ca-certificates \
  libasound2 libavahi-client3 libavahi-common3 libexpat1 \
  libflac8 libogg0 libopus0 libsoxr0 libvorbis0a \
  libvorbisenc2 samba-client

arch=$(arch)

if [ "x86_64" == ${arch} ]; then
  arch="amd64"
elif [ "armv7l" == ${arch} ]; then
  arch="armhf"
elif [ "aarch64" == ${arch} ]; then
  arch="armhf"
else
  echo "unknow arch: ${arch}"
  exit
fi

dpkg --add-architecture ${arch} || echo "failed to add architecture ${arch}"


echo "downloading snapserver release ... "
wget https://github.com/badaix/snapcast/releases/download/v0.23.0/snapserver_0.23.0-1_${arch}.deb
wget https://github.com/badaix/snapcast/releases/download/v0.23.0/snapclient_0.23.0-1_${arch}.deb

echo "installing snapserver release ... "
dpkg -i snapserver_* || true
dpkg -i snapclient_* || true
apt-get update
apt-get -f install -y

rm -rf /var/lib/apt/lists/*
rm -rf /root/.cache/*
