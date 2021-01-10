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
  bridge-utils \
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

# configure avahi
echo "enter a hostname:"
read HN
if [ -z "$HN" ]; then
  echo "hostname unchanged"
else
  hostnamectl set-hostname $HN
fi

systemctl enable avahi-daemon
systemctl restart avahi-daemon

#start stack
cd /docker/music/compose
bash ./start.sh

# make the flask application start on boot
systemctl enable /docker/music/snapcontrol/snapcontrol.service
systemctl restart snapcontrol
