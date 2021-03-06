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

# create compose stack from github
mkdir -p ${BASEDIR}
cd ${BASEDIR}
if [ -d "${BASEDIR}/.git" ]; then
  echo "updating musicserver git repo ... "
  git pull
else
  echo "cloning musicserver git repo ... "
  git clone https://github.com/rmalchow/musicserver.git .
fi

systemctl enable avahi-daemon
systemctl restart avahi-daemon

echo "downloading snapcast release ... "
rm *.deb
wget https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_${ARCH}.deb
wget https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapclient_${SNAPCAST_VERSION}-1_${ARCH}.deb

echo "installing snapcast release ... "
dpkg -i snapserver_* || true
dpkg -i snapclient_* || true

echo "installing mopidy ... "
bash ${BASEDIR}/mopidy/install/install.sh

cp ${BASEDIR}/snapserver/snapserver.conf /etc/snapserver.conf

# make the flask application start on boot
systemctl enable ${BASEDIR}/snapcontrol/snapcontrol.service
systemctl enable ${BASEDIR}/snapserver/snapserver.service
systemctl enable ${BASEDIR}/mopidy/mopidy.service
systemctl restart snapcontrol
systemctl restart snapserver
