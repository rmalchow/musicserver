#!/bin/bash

. ./bin/activate

cd $(dirname ${0})

if [ -d lib ]; then
  echo "apparently, dependencies are already installed"
else
  echo "installing dpendencies"
  pip3 install zeroconf flask flask-jsonpify flask-sqlalchemy flask-restful uwsgi requests psutil
fi

python3 main.py
