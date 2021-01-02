#!/bin/bash


set -e

cd /install

apt update
apt install curl make gcc gnupg2 wget python3-pip vim  -y

# mopidy
apt-key add mopidy.gpg
curl https://apt.mopidy.com/buster.list > /etc/apt/sources.list.d/mopidy.list

apt update
apt install mopidy mopidy-local mopidy-local-sqlite mopidy-mpd snapclient snapserver -y
cat /etc/mopidy/*

apt-get clean all

pip3 install Mopidy-Iris
pip3 install Mopidy-Muse
pip3 install Mopidy-MPD
pip3 install Mopidy-Jellyfin
pip3 install Mopidy-TuneIn


cp mopidy.conf /etc/mopidy/

chmod -R 755 /etc/mopidy


# runint
wget http://smarden.org/runit/runit-2.1.2.tar.gz
tar -xzf runit-2.1.2.tar.gz
rm -rf runit-2.1.2.tar.gz
cd admin/runit-2.1.2
package/install
package/install-man

rm -rf /root/.cache/*
rm -rf /var/lib/apt/lists/*
