#/bin/bash
set -e

# configure avahi
echo "enter a hostname:"
read HN
hostnamectl set-hostname $HN || true

export DEBIAN_FRONTEND=noninteractive
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
  pulsemixer pulseaudio-utils pamix apulse pulseaudio alsaplayer-common \
  apt-utils -y
apt-get install -y \
  wget ca-certificates \
  libasound2 libavahi-client3 libavahi-common3 libexpat1 \
  libflac8 libogg0 libopus0 libsoxr0 libvorbis0a \
  libvorbisenc2 samba-client

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
apt-get install cgroup-bin cgroup-tools libcgroup1 aufs-tools -y
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


systemctl enable avahi-daemon
systemctl restart avahi-daemon

#start stack
cd /docker/music/compose
bash ./start.sh

echo "downloading snapserver release ... "
wget https://github.com/badaix/snapcast/releases/download/v0.23.0/snapserver_0.23.0-1_armhf.deb
wget https://github.com/badaix/snapcast/releases/download/v0.23.0/snapclient_0.23.0-1_armhf.deb

echo "installing snapserver release ... "
dpkg -i snapserver_* || true
dpkg -i snapclient_* || true

cp /docker/music/snapserver/snapserver.conf /etc/snapserver

# make the flask application start on boot
systemctl enable /docker/music/snapcontrol/snapcontrol.service
systemctl enable /docker/music/snapserver/snapserver.service
systemctl restart snapcontrol
systemctl restart snapserver
