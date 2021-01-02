#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

echo "installing basics ... "
apt-get update
apt-get install -y \
  wget apt-utils ca-certificates \
  libasound2 libavahi-client3 libavahi-common3 libexpat1 \
  libflac8 libogg0 libopus0 libsoxr0 libvorbis0a \
  libvorbisenc2 \
  libasound2-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev \
  gcc make automake git g++

mkdir -p /usr/local/src
cd /usr/local/src
wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2
tar -xzf boost_1_75_0.tar.bz2



echo "downloading snapserver release ... "
cd /usr/local/src
git clone https://github.com/badaix/snapcast
cd snapcast
git checkout v0.22.0
git submodule update --init --recursive
ADD_CFLAGS="-I/usr/local/src/boost_1_75_0" make installserver

echo "installing snapserver release ... "
dpkg -i snapserver_* || true
apt-get update
apt-get -f install -y

rm -rf /var/lib/apt/lists/*
rm -rf /root/.cache/*
