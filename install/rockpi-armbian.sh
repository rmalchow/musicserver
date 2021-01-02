#/bin/bash
apt-get update
apt-get upgrade -y
apt-get install git \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  vim git \
  armbian-config -y

apt-get install snapclient -y || true
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
mkdir -p /docker/music
cd /docker/music
git clone https://gitlab.sly.io/ldap/music.git .
