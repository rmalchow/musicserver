#/bin/bash
set -e
# install basics
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

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
systemctl enable docker
systemctl restart docker

# create compose stack from github
mkdir -p /docker/music
cd /docker/music
if [ -d "/docker/music/.git" ]; then
  echo "updating musicserver git repo ... "
  git pull
else
  echo "cloning musicserver git repo ... "
  git clone https://github.com/rmalchow/musicserver.git .
fi
cd /docker/music/compose

# configure avahi
rm -rf /etc/avahi/services/*
cp /docker/music/setup/snapserver-avahi.service /etc/avahi/services/
systemctl enable avahi-daemon
systemctl restart avahi-daemon
bash ./start.sh
