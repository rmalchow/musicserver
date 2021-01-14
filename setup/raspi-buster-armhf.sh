#/bin/bash
set -e

export SNAPCAST_VERSION=0.22.0
export BASEDIR=/music
export ARCH=armhf

bash $(dirname ${0})/install.sh
