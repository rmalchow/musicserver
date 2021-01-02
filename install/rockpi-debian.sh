#/bin/bash
apt update
apt upgrade
apt install git \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common  -y

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt install snapclient -y || true
wget -O -  apt.radxa.com/stretch/public.key | sudo apt-key add -

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose gitlab-runner -y
mkdir -p /docker/music
cd /docker/music

git clone https://gitlab.sly.io/ldap/music.git
