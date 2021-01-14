#/bin/bash
set -e

export SNAPCAST_VERSION=0.23.0
export BASEDIR=/music
export ARCH=amd64

bash $(dirname ${0})/install.sh
