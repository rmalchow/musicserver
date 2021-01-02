#/bin/bash
set -e
apt-get update
apt-get upgrade -y
apt-get install git \
  apt-transport-https \
  ca-certificates \
  alsa-utils \
  curl \
  gnupg-agent \
  software-properties-common \
  vim git avahi-daemon avahi-utils \
  pulsemixer pulseaudio-utils pamix apulse pulseaudio alsaplayer-common -y
apt-get install snapclient -y || true
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
mkdir -p /docker/music
cd /docker/music
git clone https://gitlab.sly.io/ldap/music.git .
cd /docker/music/compose
rm -rf /etc/avahi/services/*
cp /docker/music/setup/snapserver-avahi.service /etc/avahi/services/
systemctl enable avahi-daemon
systemctl restart avahi-daemon
bash ./start.sh
