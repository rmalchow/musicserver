#!/bin/bash

set -e

cd /install

# mopidy
echo "installing mopidy repo ... "
apt-key add mopidy.gpg
cp mopidy.list /etc/apt/sources.list.d/mopidy.list

apt update
echo "installing mopidy packages ... "
apt install mopidy mopidy-local mopidy-local-sqlite mopidy-mpd snapclient snapserver -y
cat /etc/mopidy/*

apt-get clean all

echo "installing mopidy modules ... "
pip3 install Mopidy-Iris
pip3 install Mopidy-Muse
pip3 install Mopidy-MPD
pip3 install Mopidy-Jellyfin
pip3 install Mopidy-TuneIn

cp mopidy.conf /etc/mopidy/
chmod -R 755 /etc/mopidy

rm -rf /root/.cache/*
rm -rf /var/lib/apt/lists/*
