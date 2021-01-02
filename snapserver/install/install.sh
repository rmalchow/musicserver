#!/bin/bash

apt-get update

apt-get install -y wget apt-utils ca-certificates

wget https://github.com/badaix/snapcast/releases/download/v0.22.0/snapserver_0.22.0-1_$(arch | sed s:"x86_64":"amd64":g).deb
dpkg -i snapserver_* || true
apt-get update
apt-get -f install -y

rm -rf /var/lib/apt/lists/*
rm -rf /root/.cache/*
