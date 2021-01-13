#!/bin/bash

set -e

cd $(dirname $0)

apt update
echo "installing basics ... "
apt install apt-utils gnupg2 python3-pip  -y

# mopidy
echo "installing mopidy repo ... "
apt-key add mopidy.gpg
cp mopidy.list /etc/apt/sources.list.d/mopidy.list

apt update
echo "installing mopidy packages ... "
apt install mopidy mopidy-local mopidy-local-sqlite mopidy-mpd -y
apt-get clean all

cp mopidy.conf /etc/mopidy

echo "installing mopidy modules ... "
pip3 install Mopidy-Iris
pip3 install Mopidy-Muse
pip3 install Mopidy-MPD
pip3 install Mopidy-Jellyfin
pip3 install Mopidy-TuneIn

chmod -R 755 /etc/mopidy

rm -rf /root/.cache/*
rm -rf /var/lib/apt/lists/*
